
package org.example.usuario;

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

    @GetMapping
    public String listarUsuarios(Model model) {
        model.addAttribute("usuarios", usuarioService.listarUsuarios());

        return "admin/cuentas-usuario";
    }

    @PostMapping("/registrar")
    public String registrarEmpleado(
            @RequestParam String nombres,
            @RequestParam String apellidos,
            @RequestParam String correo,
            @RequestParam String contrasena,
            @RequestParam String rol,
            RedirectAttributes redirectAttributes) {

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
            RedirectAttributes redirectAttributes) {

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
