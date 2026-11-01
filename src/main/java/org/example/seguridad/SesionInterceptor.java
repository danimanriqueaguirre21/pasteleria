package org.example.seguridad;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@Component
public class SesionInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(
            HttpServletRequest request,
            HttpServletResponse response,
            Object handler) throws Exception {

        HttpSession session = request.getSession(false);
        String contexto = request.getContextPath();
        String ruta = rutaDe(request);

        if (esCarrito(ruta)) {
            return permitirCarrito(session, response, contexto);
        }

        if (session == null || session.getAttribute("idUsuario") == null) {
            String destino = contexto + "/usuario/login?siguiente="
                    + URLEncoder.encode(rutaCompleta(request), StandardCharsets.UTF_8);
            response.sendRedirect(destino);
            return false;
        }

        String rol = (String) session.getAttribute("rol");

        if ("CLIENTE".equals(rol) || "ADMINISTRADOR".equals(rol)) {
            return true;
        }

        response.sendRedirect(contexto + destinoDe(rol));
        return false;
    }

    private String destinoDe(String rol) {
        if ("CAJERO".equals(rol)) {
            return "/cajero/panel";
        }

        if ("REPARTIDOR".equals(rol)) {
            return "/repartidor/panel";
        }

        return "/usuario/login";
    }

    private boolean permitirCarrito(
            HttpSession session,
            HttpServletResponse response,
            String contexto) throws Exception {

        if (session == null || session.getAttribute("idUsuario") == null) {
            return true;
        }

        String rol = (String) session.getAttribute("rol");

        if ("CLIENTE".equals(rol) || "ADMINISTRADOR".equals(rol)) {
            return true;
        }

        response.sendRedirect(contexto + destinoDe(rol));
        return false;
    }

    private String rutaDe(HttpServletRequest request) {
        String uri = request.getRequestURI();
        String contexto = request.getContextPath();

        if (contexto != null && !contexto.isEmpty() && uri.startsWith(contexto)) {
            return uri.substring(contexto.length());
        }

        return uri;
    }

    private boolean esCarrito(String ruta) {
        return "/carrito".equals(ruta) || ruta.startsWith("/carrito/");
    }

    private String rutaCompleta(HttpServletRequest request) {
        String ruta = rutaDe(request);
        String consulta = request.getQueryString();

        if (consulta == null || consulta.isBlank()) {
            return ruta;
        }

        return ruta + "?" + consulta;
    }
}
