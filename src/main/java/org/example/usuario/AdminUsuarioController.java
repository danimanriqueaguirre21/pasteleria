
package org.example.usuario;

import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/usuarios")
public class AdminUsuarioController {

    private final UsuarioService usuarioService;

    public AdminUsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    private boolean esAdministrador(HttpSession session) {
        Integer idUsuario = (Integer) session.getAttribute("idUsuario");
        return usuarioService.tieneRol(idUsuario, "ADMINISTRADOR");
    }

    @GetMapping
    public String listarUsuarios(HttpSession session, Model model) {
        if (!esAdministrador(session)) {
            return "redirect:/catalogo";
        }

        model.addAttribute("usuarios", usuarioService.listarUsuarios());
        model.addAttribute("idRolAdministrador", usuarioService.obtenerIdRol("ADMINISTRADOR"));
        model.addAttribute("idRolCliente", usuarioService.obtenerIdRol("CLIENTE"));
        model.addAttribute("idRolCajero", usuarioService.obtenerIdRol("CAJERO"));
        model.addAttribute("idRolRepartidor", usuarioService.obtenerIdRol("REPARTIDOR"));

        return "admin/usuarios";
    }

    @PostMapping("/registrar")
    public String registrarEmpleado(
            @RequestParam String nombres,
            @RequestParam String apellidos,
            @RequestParam String correo,
            @RequestParam String contrasena,
            @RequestParam String rol,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (!esAdministrador(session)) {
            return "redirect:/catalogo";
        }

        try {
            Usuario usuario = new Usuario();
            usuario.setNombres(nombres);
            usuario.setApellidos(apellidos);
            usuario.setCorreo(correo);
            usuario.setContrasena(contrasena);

            usuarioService.registrarEmpleado(usuario, rol);

            redirectAttributes.addFlashAttribute("mensaje", "Cuenta creada correctamente.");

        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/admin/usuarios";
    }

    @PostMapping("/estado")
    public String actualizarEstado(
            @RequestParam int idUsuario,
            @RequestParam boolean estado,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        if (!esAdministrador(session)) {
            return "redirect:/catalogo";
        }

        try {
            usuarioService.actualizarEstado(idUsuario, estado);

            String mensaje = estado
                    ? "Usuario activado correctamente."
                    : "Usuario desactivado correctamente.";

            redirectAttributes.addFlashAttribute("mensaje", mensaje);

        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/admin/usuarios";
    }
}
