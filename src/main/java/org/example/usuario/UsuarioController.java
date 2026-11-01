
package org.example.usuario;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Controller
@RequestMapping("/usuario")
public class UsuarioController {

    private final UsuarioService usuarioService;

    public UsuarioController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @GetMapping("/registro")
    public String mostrarRegistro(
            @RequestParam(required = false) String siguiente,
            Model model) {

        recordarDestino(siguiente, model);
        return "usuario/crear-cuenta";
    }

    @PostMapping("/registrar")
    public String registrarUsuario(
            @RequestParam String nombres,
            @RequestParam String apellidos,
            @RequestParam String correo,
            @RequestParam String contrasena,
            @RequestParam(required = false) String siguiente,
            Model model) {

        try {
            Usuario usuario = new Usuario();
            usuario.setNombres(nombres);
            usuario.setApellidos(apellidos);
            usuario.setCorreo(correo);
            usuario.setContrasena(contrasena);

            usuarioService.registrarUsuario(usuario);

            if (siguienteSeguro(siguiente)) {
                return "redirect:/usuario/login?registro=exitoso&siguiente="
                        + URLEncoder.encode(siguiente, StandardCharsets.UTF_8);
            }

            return "redirect:/usuario/login?registro=exitoso";

        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            recordarDestino(siguiente, model);
            return "usuario/crear-cuenta";
        }
    }

    @GetMapping("/login")
    public String mostrarLogin(
            @RequestParam(required = false) String registro,
            @RequestParam(required = false) String siguiente,
            Model model) {

        if ("exitoso".equals(registro)) {
            model.addAttribute("mensaje", "Registro exitoso. Ahora puedes iniciar sesión.");
        } else if (siguiente != null && siguiente.startsWith("/pedido/confirmar")) {
            model.addAttribute("mensaje", "Inicia sesión para finalizar tu compra.");
        }

        recordarDestino(siguiente, model);
        return "usuario/iniciar-sesion";
    }

    @PostMapping("/login")
    public String iniciarSesion(
            @RequestParam String correo,
            @RequestParam String contrasena,
            @RequestParam(required = false) String siguiente,
            HttpServletRequest request,
            Model model) {

        Usuario usuario = usuarioService.iniciarSesion(correo, contrasena);

        if (usuario == null) {
            model.addAttribute("error", "Correo o contraseña incorrectos, o cuenta inactiva.");
            recordarDestino(siguiente, model);
            return "usuario/iniciar-sesion";
        }

        HttpSession sesionAnterior = request.getSession(false);
        Object carrito = sesionAnterior == null
                ? null
                : sesionAnterior.getAttribute("carrito");

        if (sesionAnterior != null) {
            sesionAnterior.invalidate();
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("idUsuario", usuario.getIdUsuario());
        session.setAttribute("nombreUsuario", usuario.getNombres());
        session.setAttribute("rol", usuario.getRol());

        if (carrito != null) {
            session.setAttribute("carrito", carrito);
        }

        String panel = destinoTrasLogin(usuario.getRol(), siguiente);

        if (panel != null) {
            return panel;
        }

        session.invalidate();
        model.addAttribute("error", "Tu cuenta no tiene un rol válido.");

        return "usuario/iniciar-sesion";
    }

    private void recordarDestino(String siguiente, Model model) {
        if (siguienteSeguro(siguiente)) {
            model.addAttribute("siguiente", siguiente);
            model.addAttribute(
                    "siguienteUrl",
                    URLEncoder.encode(siguiente, StandardCharsets.UTF_8)
            );
        }
    }

    private String destinoTrasLogin(String rol, String siguiente) {
        if (("CLIENTE".equals(rol) || "ADMINISTRADOR".equals(rol))
                && siguienteSeguro(siguiente)) {
            return "redirect:" + siguiente;
        }

        return panelDeRol(rol);
    }

    private boolean siguienteSeguro(String siguiente) {
        if (siguiente == null || siguiente.isBlank()) {
            return false;
        }

        if (siguiente.contains(" ") || siguiente.contains("..") || siguiente.contains("\\")) {
            return false;
        }

        String ruta = siguiente;
        int separador = siguiente.indexOf('?');

        if (separador >= 0) {
            ruta = siguiente.substring(0, separador);
            String consulta = siguiente.substring(separador + 1);

            if (consulta.isBlank() || !caracteresDeConsulta(consulta)) {
                return false;
            }
        }

        boolean rutaConocida = ruta.equals("/pedido")
                || ruta.startsWith("/pedido/")
                || ruta.equals("/carrito")
                || ruta.startsWith("/carrito/")
                || ruta.equals("/catalogo")
                || ruta.startsWith("/catalogo/");

        return rutaConocida && caracteresDeRuta(ruta);
    }

    private boolean caracteresDeRuta(String ruta) {
        for (int i = 0; i < ruta.length(); i++) {
            char caracter = ruta.charAt(i);
            boolean permitido = caracter == '/'
                    || caracter == '-'
                    || caracter == '_'
                    || Character.isLetterOrDigit(caracter);

            if (!permitido) {
                return false;
            }
        }

        return true;
    }

    private boolean caracteresDeConsulta(String consulta) {
        for (int i = 0; i < consulta.length(); i++) {
            char caracter = consulta.charAt(i);
            boolean permitido = caracter == '.'
                    || caracter == '_'
                    || caracter == '-'
                    || caracter == '='
                    || caracter == '&'
                    || caracter == '%'
                    || Character.isLetterOrDigit(caracter);

            if (!permitido) {
                return false;
            }
        }

        return true;
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
