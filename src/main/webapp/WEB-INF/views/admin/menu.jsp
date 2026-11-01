<%@ page pageEncoding="UTF-8" %>
<aside class="admin-lateral">
    <div class="admin-marca">
        <span class="admin-marca-icono" aria-hidden="true">
            <svg viewBox="0 0 24 24" width="22" height="22">
                <path d="M5 13h14v5a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2v-5z" fill="none" stroke="currentColor" stroke-width="1.8"/>
                <path d="M5 13c1.3-1.7 2.4-1.7 3.7 0s2.4 1.7 3.7 0 2.4-1.7 3.7 0 2.4 1.7 2.9 0" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
                <path d="M12 10V6" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
                <circle cx="12" cy="4.5" r="1" fill="currentColor"/>
            </svg>
        </span>
        <div>
            <strong>Mi Pastelería</strong>
            <p>Endulzamos tus mejores momentos</p>
        </div>
    </div>

    <nav class="menu-admin" aria-label="Administración">
        <a href="${pageContext.request.contextPath}/catalogo">
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 10.5 12 4l8 6.5V20a1 1 0 0 1-1 1h-5v-6H10v6H5a1 1 0 0 1-1-1v-9.5z" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/></svg>
            Catálogo
        </a>

        <a href="${pageContext.request.contextPath}/productos"<c:if test="${menuActivo eq 'productos'}"> aria-current="page"</c:if>>
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 7V5a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M5 7h14l-1 13H6L5 7z" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/></svg>
            Productos
        </a>

        <a href="${pageContext.request.contextPath}/categorias"<c:if test="${menuActivo eq 'categorias'}"> aria-current="page"</c:if>>
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M4 7h7l2 2h7v9a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V7z" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linejoin="round"/></svg>
            Categorías
        </a>

        <a href="${pageContext.request.contextPath}/admin/pedidos"<c:if test="${menuActivo eq 'pedidos'}"> aria-current="page"</c:if>>
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 7h11l-1 5H8L7 4H4M9 20a1 1 0 1 0 0-2 1 1 0 0 0 0 2zm8 0a1 1 0 1 0 0-2 1 1 0 0 0 0 2z" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg>
            Pedidos
        </a>

        <a href="${pageContext.request.contextPath}/admin/estadisticas"<c:if test="${menuActivo eq 'dashboard'}"> aria-current="page"</c:if>>
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M5 19V10M12 19V5M19 19v-7" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>
            Resumen
        </a>

        <a href="${pageContext.request.contextPath}/admin/usuarios"<c:if test="${menuActivo eq 'usuarios'}"> aria-current="page"</c:if>>
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M16 19v-1a3 3 0 0 0-3-3H7a3 3 0 0 0-3 3v1M10 12a3 3 0 1 0 0-6 3 3 0 0 0 0 6zm8 7v-1a3 3 0 0 0-2-2.8M16 6.1a3 3 0 0 1 0 5.8" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/></svg>
            Usuarios
        </a>
    </nav>

    <form class="admin-salir" action="${pageContext.request.contextPath}/usuario/logout" method="post">
        <c:if test="${not empty _csrf}">
            <input type="hidden"
                   name="${_csrf.parameterName}"
                   value="${_csrf.token}">
        </c:if>
        <button type="submit">
            <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M10 7V5a1 1 0 0 1 1-1h8v16h-8a1 1 0 0 1-1-1v-2M4 12h11M12 8l4 4-4 4" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/></svg>
            Cerrar sesión
        </button>
    </form>
</aside>

<header class="admin-encabezado">
    <h1><c:out value="${tituloAdmin}"/></h1>
    <c:if test="${menuActivo eq 'dashboard'}">
        <p class="admin-fecha">
            <%= new java.text.SimpleDateFormat("d 'de' MMMM 'de' yyyy", java.util.Locale.forLanguageTag("es-PE")).format(new java.util.Date()) %>
        </p>
    </c:if>
</header>
