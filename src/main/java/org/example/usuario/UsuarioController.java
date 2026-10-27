
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
    private final UsuarioDAO usuarioDAO;

    public UsuarioController(UsuarioService usuarioService, UsuarioDAO usuarioDAO) {
        this.usuarioService = usuarioService;
        this.usuarioDAO = usuarioDAO;
    }

    @GetMapping("/registro")
    public String mostrarRegistro() {
        return "usuario/registro";
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
            return "usuario/registro";
        }
    }

    @GetMapping("/login")
    public String mostrarLogin(
            @RequestParam(required = false) String registro,
            Model model) {

        if ("exitoso".equals(registro)) {
            model.addAttribute("mensaje", "Registro exitoso. Ahora puedes iniciar sesión.");
        }

        return "usuario/login";
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
            return "usuario/login";
        }

        HttpSession sesionAnterior = request.getSession(false);

        if (sesionAnterior != null) {
            sesionAnterior.invalidate();
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("idUsuario", usuario.getIdUsuario());
        session.setAttribute("nombreUsuario", usuario.getNombres());
        session.setAttribute("idRol", usuario.getIdRol());

        int idRolAdministrador = usuarioDAO.obtenerIdRolPorNombre("ADMINISTRADOR");
        int idRolCliente = usuarioDAO.obtenerIdRolPorNombre("CLIENTE");
        int idRolCajero = usuarioDAO.obtenerIdRolPorNombre("CAJERO");
        int idRolRepartidor = usuarioDAO.obtenerIdRolPorNombre("REPARTIDOR");

        if (usuario.getIdRol() == idRolAdministrador) {
            return "redirect:/admin/estadisticas";
        }

        if (usuario.getIdRol() == idRolCajero) {
            return "redirect:/cajero/panel";
        }

        if (usuario.getIdRol() == idRolRepartidor) {
            return "redirect:/repartidor/panel";
        }

        if (usuario.getIdRol() == idRolCliente) {
            return "redirect:/catalogo";
        }

        session.invalidate();
        model.addAttribute("error", "Tu cuenta no tiene un rol válido.");

        return "usuario/login";
    }

    @PostMapping("/logout")
    public String cerrarSesion(HttpSession session) {
        session.invalidate();
        return "redirect:/usuario/login";
    }
}
