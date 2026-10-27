package org.example.seguridad;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.usuario.UsuarioDAO;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class MenuClienteInterceptor implements HandlerInterceptor {

    private final UsuarioDAO usuarioDAO;

    public MenuClienteInterceptor(UsuarioDAO usuarioDAO) {
        this.usuarioDAO = usuarioDAO;
    }

    @Override
    public boolean preHandle(
            HttpServletRequest request,
            HttpServletResponse response,
            Object handler) throws Exception {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("idRol") == null) {
            return true;
        }

        Integer idRol = (Integer) session.getAttribute("idRol");

        int idRolCajero = usuarioDAO.obtenerIdRolPorNombre("CAJERO");

        if (idRol.equals(idRolCajero)) {
            response.sendRedirect(
                    request.getContextPath() + "/cajero/panel"
            );

            return false;
        }

        return true;
    }
}
