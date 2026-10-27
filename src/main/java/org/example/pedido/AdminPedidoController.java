
package org.example.pedido;

import jakarta.servlet.http.HttpSession;
import org.example.usuario.UsuarioService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/pedidos")
public class AdminPedidoController {

    private final PedidoService pedidoService;
    private final UsuarioService usuarioService;

    public AdminPedidoController(PedidoService pedidoService, UsuarioService usuarioService) {
        this.pedidoService = pedidoService;
        this.usuarioService = usuarioService;
    }

    private boolean esAdministrador(HttpSession session) {
        Integer idUsuario = (Integer) session.getAttribute("idUsuario");
        return usuarioService.tieneRol(idUsuario, "ADMINISTRADOR");
    }

    @GetMapping
    public String listarPedidos(HttpSession session, Model model) {
        if (!esAdministrador(session)) {
            return "redirect:/usuario/login";
        }

        List<Pedido> pedidos = pedidoService.listarTodosLosPedidos();

        model.addAttribute("bloques", pedidoService.agruparPorEstado(pedidos));
        model.addAttribute("nombresClientes", pedidoService.nombresDeClientes(pedidos));
        model.addAttribute("resumenProductos", pedidoService.resumirProductos());

        return "admin/pedidos";
    }

    @PostMapping("/estado")
    public String actualizarEstado(
            @RequestParam int idPedido,
            @RequestParam String nuevoEstado,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (!esAdministrador(session)) {
            return "redirect:/usuario/login";
        }

        try {
            pedidoService.actualizarEstadoPedido(idPedido, nuevoEstado);

            redirectAttributes.addFlashAttribute(
                    "mensaje",
                    "El pedido #" + idPedido + " cambió a " + nuevoEstado + "."
            );

        } catch (IllegalArgumentException | IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/admin/pedidos";
    }
}
