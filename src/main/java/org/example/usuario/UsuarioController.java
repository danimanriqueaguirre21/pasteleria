
package org.example.usuario;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/usuario")
public class UsuarioController {

    private final UsuarioService usuarioService;

    public UsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @GetMapping("/registro")
    public String mostrarRegistro() {
        return "usuario/crear-cuenta";
    }

    @PostMapping("/registrar")
    public String registrarUsuario(
            @RequestParam String nombres,
            @RequestParam String apellidos,
            @RequestParam String correo,
            @RequestParam String contrasena,
            Model model) {

        try {
            Usuario usuario = new Usuario();
            usuario.setNombres(nombres);
            usuario.setApellidos(apellidos);
            usuario.setCorreo(correo);
            usuario.setContrasena(contrasena);

            usuarioService.registrarUsuario(usuario);

            return "redirect:/usuario/login?registro=exitoso";

        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "usuario/crear-cuenta";
        }
    }

    @GetMapping("/login")
    public String mostrarLogin(
            @RequestParam(required = false) String registro,
            Model model) {

        if ("exitoso".equals(registro)) {
            model.addAttribute("mensaje", "Registro exitoso. Ahora puedes iniciar sesión.");
        }

        return "usuario/iniciar-sesion";
    }

    @PostMapping("/login")
    public String iniciarSesion(
            @RequestParam String correo,
            @RequestParam String contrasena,
            HttpServletRequest request,
            Model model) {

        Usuario usuario = usuarioService.iniciarSesion(correo, contrasena);

        if (usuario == null) {
            model.addAttribute("error", "Correo o contraseña incorrectos, o cuenta inactiva.");
            return "usuario/iniciar-sesion";
        }

        HttpSession sesionAnterior = request.getSession(false);

        if (sesionAnterior != null) {
            sesionAnterior.invalidate();
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("idUsuario", usuario.getIdUsuario());
        session.setAttribute("nombreUsuario", usuario.getNombres());
        session.setAttribute("rol", usuario.getRol());

        String panel = panelDeRol(usuario.getRol());

        if (panel != null) {
            return panel;
        }

        session.invalidate();
        model.addAttribute("error", "Tu cuenta no tiene un rol válido.");

        return "usuario/iniciar-sesion";
    }

    private String panelDeRol(String rol) {
        if (rol == null) {
            return null;
        }

        if (rol.equals("ADMINISTRADOR")) {
            return "redirect:/admin/estadisticas";
        }

        if (rol.equals("CAJERO")) {
            return "redirect:/cajero/panel";
        }

        if (rol.equals("REPARTIDOR")) {
            return "redirect:/repartidor/panel";
        }

        if (rol.equals("CLIENTE")) {
            return "redirect:/catalogo";
        }

        return null;
    }

    @PostMapping("/logout")
    public String cerrarSesion(HttpSession session) {
        session.invalidate();
        return "redirect:/usuario/login";
    }
}
