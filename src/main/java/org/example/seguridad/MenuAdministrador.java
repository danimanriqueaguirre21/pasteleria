package org.example.seguridad;

import jakarta.servlet.http.HttpSession;
import org.example.usuario.UsuarioService;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class MenuAdministrador {

    private final UsuarioService usuarioService;

    public MenuAdministrador(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @ModelAttribute("esAdministrador")
    public boolean esAdministrador(HttpSession session) {
        Integer idUsuario = (Integer) session.getAttribute("idUsuario");
        return usuarioService.tieneRol(idUsuario, "ADMINISTRADOR");
    }
}
