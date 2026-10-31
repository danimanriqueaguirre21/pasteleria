package org.example.repartidor;

import jakarta.servlet.http.HttpSession;
import org.example.pedido.Pedido;
import org.example.pedido.PedidoService;
import org.example.usuario.UsuarioService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/repartidor")
public class RepartidorController {

    private final RepartidorService repartidorService;
    private final UsuarioService usuarioService;
    private final PedidoService pedidoService;

    public RepartidorController(
            RepartidorService repartidorService,
            UsuarioService usuarioService,
            PedidoService pedidoService) {
        this.repartidorService = repartidorService;
        this.usuarioService = usuarioService;
        this.pedidoService = pedidoService;
    }

    private boolean esRepartidor(HttpSession session) {
        Integer idUsuario = (Integer) session.getAttribute("idUsuario");
        return usuarioService.tieneRol(idUsuario, "REPARTIDOR");
    }

    @GetMapping("/panel")
    public String mostrarPanel(
            HttpSession session,
            Model model) {

        if (!esRepartidor(session)) {
            return "redirect:/usuario/login";
        }

        Integer idRepartidor =
                (Integer) session.getAttribute("idUsuario");

        List<Pedido> pedidos =
                repartidorService.listarPedidosPorRepartidor(
                        idRepartidor);
        Map<String, Long> conteo = pedidoService.contarPorEstado(pedidos);

        model.addAttribute("pedidos", pedidos);
        model.addAttribute(
                "nombresClientes",
                pedidoService.nombresDeClientes(pedidos));
        model.addAttribute("asignados", conteo.get("ASIGNADO"));
        model.addAttribute("enCamino", conteo.get("EN CAMINO"));
        model.addAttribute("entregados", conteo.get("ENTREGADO"));
        model.addAttribute("totalPedidos", pedidos.size());

        return "repartidor/mis-entregas";
    }

    @PostMapping("/iniciar-reparto")
    public String iniciarReparto(
            @RequestParam int idPedido,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (!esRepartidor(session)) {
            return "redirect:/usuario/login";
        }

        Integer idRepartidor =
                (Integer) session.getAttribute("idUsuario");

        try {
            repartidorService.iniciarReparto(
                    idPedido,
                    idRepartidor);

            redirectAttributes.addFlashAttribute(
                    "mensaje",
                    "Pedido #" + idPedido
                            + " recogido. Ahora está EN CAMINO.");

        } catch (IllegalArgumentException
                 | IllegalStateException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage());
        }

        return "redirect:/repartidor/panel";
    }

    @PostMapping("/confirmar-entrega")
    public String confirmarEntrega(
            @RequestParam int idPedido,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (!esRepartidor(session)) {
            return "redirect:/usuario/login";
        }

        Integer idRepartidor =
                (Integer) session.getAttribute("idUsuario");

        try {
            repartidorService.confirmarEntrega(
                    idPedido,
                    idRepartidor);

            redirectAttributes.addFlashAttribute(
                    "mensaje",
                    "Pedido #" + idPedido
                            + " entregado correctamente.");

        } catch (IllegalArgumentException
                 | IllegalStateException e) {

            redirectAttributes.addFlashAttribute(
                    "error",
                    e.getMessage());
        }

        return "redirect:/repartidor/panel";
    }
}