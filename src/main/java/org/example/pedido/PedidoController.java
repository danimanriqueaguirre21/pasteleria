
package org.example.pedido;

import jakarta.servlet.http.HttpSession;
import org.example.carrito.CarritoService;
import org.example.carrito.ItemCarrito;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Locale;

@Controller
public class PedidoController {

    private final PedidoService pedidoService;
    private final CarritoService carritoService;

    public PedidoController(PedidoService pedidoService, CarritoService carritoService) {
        this.pedidoService = pedidoService;
        this.carritoService = carritoService;
    }

    @GetMapping("/pedido/confirmar")
    public String mostrarConfirmacion(
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {

        Integer idUsuario = (Integer) session.getAttribute("idUsuario");

        if (idUsuario == null) {
            return "redirect:/usuario/login";
        }

        List<ItemCarrito> carrito = obtenerCarrito(session);

        if (carrito == null || carrito.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Tu carrito está vacío.");
            return "redirect:/carrito";
        }

        model.addAttribute("carrito", carrito);
        model.addAttribute("total", carritoService.calcularTotal(carrito));

        return "pedido/confirmar";
    }

    @PostMapping("/pedido/confirmar")
    public String confirmarPedido(
            @RequestParam String direccionEntrega,
            @RequestParam String telefono,
            @RequestParam(required = false) String medioPago,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Integer idUsuario = (Integer) session.getAttribute("idUsuario");

        if (idUsuario == null) {
            return "redirect:/usuario/login";
        }

        List<ItemCarrito> carrito = obtenerCarrito(session);

        if (carrito == null || carrito.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Tu carrito está vacío.");
            return "redirect:/carrito";
        }

        try {
            int idPedido = pedidoService.confirmarPedido(
                    idUsuario,
                    direccionEntrega,
                    telefono,
                    medioPago,
                    carrito
            );

            session.removeAttribute("carrito");

            return "redirect:/pedido/exito?id=" + idPedido;

        } catch (IllegalArgumentException | IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            redirectAttributes.addFlashAttribute("direccionEntrega", direccionEntrega);
            redirectAttributes.addFlashAttribute("telefono", telefono);
            redirectAttributes.addFlashAttribute("medioPago", medioPago);

            return "redirect:/pedido/confirmar";
        }
    }

    @GetMapping("/pedido/exito")
    public String mostrarExito(
            @RequestParam int id,
            HttpSession session,
            Model model) {

        Integer idUsuario = (Integer) session.getAttribute("idUsuario");

        if (idUsuario == null) {
            return "redirect:/usuario/login";
        }

        Pedido pedido = pedidoService.obtenerPedidoPorId(id);

        if (pedido == null || !idUsuario.equals(pedido.getIdUsuario())) {
            return "redirect:/pedido/historial";
        }

        model.addAttribute("pedido", pedido);

        return "pedido/exito";
    }

    @GetMapping("/pedido/historial")
    public String mostrarHistorial(HttpSession session, Model model) {
        Integer idUsuario = (Integer) session.getAttribute("idUsuario");

        if (idUsuario == null) {
            return "redirect:/usuario/login";
        }

        model.addAttribute(
                "pedidos",
                pedidoService.listarPedidosPorUsuario(idUsuario)
        );

        return "pedido/historial";
    }

    @GetMapping("/pedido/detalle")
    public String mostrarDetalle(
            @RequestParam("id") int idPedido,
            HttpSession session,
            Model model) {

        Integer idUsuario = (Integer) session.getAttribute("idUsuario");

        if (idUsuario == null) {
            return "redirect:/usuario/login";
        }

        Pedido pedido = pedidoService.obtenerPedidoPorId(idPedido);

        if (pedido == null || !idUsuario.equals(pedido.getIdUsuario())) {
            return "redirect:/pedido/historial";
        }

        model.addAttribute("pedido", pedido);
        model.addAttribute(
                "detalles",
                pedidoService.listarDetallesPorPedido(idPedido)
        );

        return "pedido/detalle";
    }

    @PostMapping("/pedido/cancelar")
    public String cancelarPedido(
            @RequestParam int idPedido,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Integer idUsuario = (Integer) session.getAttribute("idUsuario");

        if (idUsuario == null) {
            return "redirect:/usuario/login";
        }

        try {
            pedidoService.cancelarPedido(idPedido, idUsuario);

            redirectAttributes.addFlashAttribute(
                    "mensaje",
                    "Pedido #" + idPedido + " cancelado correctamente."
            );

        } catch (IllegalArgumentException | IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/pedido/historial";
    }

    @GetMapping("/pedido/seguimiento")
    public String mostrarSeguimiento(
            @RequestParam(required = false) String codigo,
            HttpSession session,
            Model model) {

        Integer idUsuario = (Integer) session.getAttribute("idUsuario");

        if (idUsuario == null) {
            return "redirect:/usuario/login";
        }

        if (codigo == null || codigo.isBlank()) {
            return "pedido/seguimiento";
        }

        String codigoNormalizado = codigo.trim().toUpperCase(Locale.ROOT);

        model.addAttribute("codigoBuscado", codigoNormalizado);

        if (codigoNormalizado.length() > 30) {
            model.addAttribute("error", "El código de seguimiento es demasiado largo.");
            return "pedido/seguimiento";
        }

        try {
            Pedido pedido = pedidoService.obtenerPedidoPorCodigoSeguimiento(codigoNormalizado);

            if (pedido == null || !idUsuario.equals(pedido.getIdUsuario())) {
                model.addAttribute(
                        "error",
                        "No se encontró ningún pedido con ese código."
                );
            } else {
                model.addAttribute("pedido", pedido);
            }

        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
        }

        return "pedido/seguimiento";
    }

    @SuppressWarnings("unchecked")
    private List<ItemCarrito> obtenerCarrito(HttpSession session) {
        return (List<ItemCarrito>) session.getAttribute("carrito");
    }
}
