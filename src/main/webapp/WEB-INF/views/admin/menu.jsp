<%@ page pageEncoding="UTF-8" %>
<header class="cabecera-admin">
    <h1><c:out value="${tituloAdmin}"/></h1>

    <nav class="menu-admin" aria-label="Administraci&oacute;n">
        <a href="${pageContext.request.contextPath}/catalogo">Cat&aacute;logo</a>

        <a href="${pageContext.request.contextPath}/productos"<c:if test="${menuActivo eq 'productos'}"> aria-current="page"</c:if>>
            Productos
        </a>

        <a href="${pageContext.request.contextPath}/categorias"<c:if test="${menuActivo eq 'categorias'}"> aria-current="page"</c:if>>
            Categor&iacute;as
        </a>

        <a href="${pageContext.request.contextPath}/admin/pedidos"<c:if test="${menuActivo eq 'pedidos'}"> aria-current="page"</c:if>>
            Pedidos
        </a>

        <a href="${pageContext.request.contextPath}/admin/estadisticas"<c:if test="${menuActivo eq 'dashboard'}"> aria-current="page"</c:if>>
            Resumen
        </a>

        <a href="${pageContext.request.contextPath}/admin/usuarios"<c:if test="${menuActivo eq 'usuarios'}"> aria-current="page"</c:if>>
            Usuarios
        </a>

        <form action="${pageContext.request.contextPath}/usuario/logout" method="post">
            <c:if test="${not empty _csrf}">
                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}">
            </c:if>
            <button type="submit">Cerrar sesi&oacute;n</button>
        </form>
    </nav>
</header>
