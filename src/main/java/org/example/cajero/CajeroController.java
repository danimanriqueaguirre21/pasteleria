package org.example.cajero;

import jakarta.servlet.http.HttpSession;
import org.example.pedido.Pedido;
import org.example.pedido.PedidoService;
import org.example.producto.ProductoService;
import org.example.repartidor.RepartidorService;
import org.example.usuario.UsuarioService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.example.usuario.Usuario;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Controller
@RequestMapping("/cajero")
public class CajeroController {

    private final PedidoService pedidoService;
    private final RepartidorService repartidorService;
    private final UsuarioService usuarioService;
    private final ProductoService productoService;

    public CajeroController(
            PedidoService pedidoService,
            RepartidorService repartidorService,
            UsuarioService usuarioService,
            ProductoService productoService) {

        this.pedidoService = pedidoService;
        this.repartidorService = repartidorService;
        this.usuarioService = usuarioService;
        this.productoService = productoService;
    }

    @GetMapping("/panel")
    public String mostrarPanel(HttpSession session, Model model) {
        if (!esCajero(session)) {
            return "redirect:/usuario/login";
        }

        List<Pedido> pedidos = pedidoService.listarTodosLosPedidos();
        Map<String, List<Pedido>> bloques = pedidoService.agruparPorEstado(pedidos);
        Map<String, Long> conteo = pedidoService.contarPorEstado(pedidos);

        model.addAttribute("bloques", bloques);
        model.addAttribute("nombresClientes", pedidoService.nombresDeClientes(pedidos));
        model.addAttribute("nombresRepartidores", nombresRepartidores(pedidos));
        model.addAttribute("pendientes", conteo.get("RECIBIDO"));
        model.addAttribute("enPreparacion", conteo.get("EN PREPARACIÓN"));
        model.addAttribute("asignados", conteo.get("ASIGNADO"));
        model.addAttribute("enCamino", conteo.get("EN CAMINO"));
        model.addAttribute("entregados", conteo.get("ENTREGADO"));
        List<Usuario> repartidoresActivos = usuarioService.listarActivosPorRol("REPARTIDOR");
        Set<Integer> ocupados = new HashSet<>(repartidorService.listarIdsConPedidoPendiente());
        List<Usuario> repartidoresLibres = new ArrayList<>();

        for (Usuario repartidor : repartidoresActivos) {
            if (!ocupados.contains(repartidor.getIdUsuario())) {
                repartidoresLibres.add(repartidor);
            }
        }

        model.addAttribute("repartidores", repartidoresLibres);
        model.addAttribute("hayRepartidoresOcupados", repartidoresActivos.size() > repartidoresLibres.size());
        model.addAttribute("productos", productoService.listarProductosActivos());

        return "cajero/punto-de-venta";
    }

    @PostMapping("/venta")
    public String registrarVenta(
            @RequestParam String telefono,
            @RequestParam String medioPago,
            @RequestParam(required = false) List<Integer> idProducto,
            @RequestParam(required = false) List<String> cantidad,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (!esCajero(session)) {
            return "redirect:/usuario/login";
        }

        try {
            int idPedido = pedidoService.registrarVentaEnTienda(
                    telefono,
                    medioPago,
                    idProducto,
                    pedidoService.leerCantidades(cantidad)
            );

            redirectAttributes.addFlashAttribute(
                    "mensaje",
                    "Venta en tienda registrada. Pedido #" + idPedido
            );
        } catch (IllegalArgumentException | IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/cajero/panel";
    }

    @PostMapping("/actualizar-estado")
    public String actualizarEstado(
            @RequestParam int idPedido,
            @RequestParam String nuevoEstado,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (!esCajero(session)) {
            return "redirect:/usuario/login";
        }

        try {
            pedidoService.actualizarEstadoPedido(idPedido, nuevoEstado);
            redirectAttributes.addFlashAttribute(
                    "mensaje",
                    "El pedido #" + idPedido + " se actualizó a " + textoEstado(nuevoEstado)
            );
        } catch (IllegalArgumentException | IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/cajero/panel";
    }

    @PostMapping("/asignar-repartidor")
    public String asignarRepartidor(
            @RequestParam int idPedido,
            @RequestParam int idRepartidor,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (!esCajero(session)) {
            return "redirect:/usuario/login";
        }

        try {
            repartidorService.asignarRepartidor(idPedido, idRepartidor);
            redirectAttributes.addFlashAttribute(
                    "mensaje",
                    "El pedido #" + idPedido + " fue asignado correctamente al repartidor"
            );
        } catch (IllegalArgumentException | IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/cajero/panel";
    }

    private Map<Integer, String> nombresRepartidores(List<Pedido> pedidos) {
        Set<Integer> ids = new HashSet<>();

        for (Pedido pedido : pedidos) {
            if (pedido.getIdRepartidor() != null) {
                ids.add(pedido.getIdRepartidor());
            }
        }

        Map<Integer, String> nombres = new HashMap<>();

        for (Usuario repartidor : usuarioService.buscarPorIds(ids)) {
            nombres.put(
                    repartidor.getIdUsuario(),
                    repartidor.getNombres() + " " + repartidor.getApellidos()
            );
        }

        return nombres;
    }

    private String textoEstado(String estado) {
        if ("EN PREPARACIÓN".equals(estado)) {
            return "empaquetar";
        }

        return estado;
    }

    private boolean esCajero(HttpSession session) {
        Integer idUsuario = (Integer) session.getAttribute("idUsuario");
        return usuarioService.tieneRol(idUsuario, "CAJERO");
    }
}
