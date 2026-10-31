
package org.example.seguridad;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.usuario.Usuario;
import org.example.usuario.UsuarioService;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AutorizacionInterceptor implements HandlerInterceptor {

    private final UsuarioService usuarioService;

    public AutorizacionInterceptor(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @Override
    public boolean preHandle(
            HttpServletRequest request,
            HttpServletResponse response,
            Object handler) throws Exception {

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("idUsuario") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/usuario/login"
            );

            return false;
        }

        int idUsuario =
                (Integer) session.getAttribute("idUsuario");

        Usuario usuario =
                usuarioService.obtenerUsuarioPorId(idUsuario);

        if (usuario == null || !usuario.isEstado()) {

            session.invalidate();

            response.sendRedirect(
                    request.getContextPath() + "/usuario/login"
            );

            return false;
        }

        if (!"ADMINISTRADOR".equals(usuario.getRol())) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Acceso denegado. Solo administradores."
            );

            return false;
        }

        return true;
    }
}
