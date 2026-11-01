<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de productos - Mi Pastelería</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body class="pagina-productos admin-app">
<c:set var="tituloAdmin" value="Gestión de productos"/>
<c:set var="menuActivo" value="productos"/>
<%@ include file="../admin/menu.jsp" %>
<main class="contenedor">
    <div class="barra-acciones">
        <div>
            <h2>Productos registrados</h2>
            <p>Consulta y actualiza la información de los productos de tu pastelería.</p>
        </div>
        <a class="boton boton-primario" href="${pageContext.request.contextPath}/productos/nuevo">+ Nuevo producto</a>
    </div>
    <section class="panel">
        <div class="tabla-contenedor">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <th>Precio</th>
                    <th>Stock</th>
                    <th>Categoría</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="producto" items="${productos}">
                    <tr>
                        <td class="celda-id">#<c:out value="${producto.idProducto}"/></td>
                        <td class="celda-nombre"><c:out value="${producto.nombre}"/></td>
                        <td class="celda-descripcion"><c:out value="${producto.descripcion}"/></td>
                        <td class="celda-precio">S/ <c:out value="${producto.precio}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${producto.stock == 0}"><span class="etiqueta etiqueta-agotado">Agotado</span></c:when>
                                <c:otherwise><span class="stock"><c:out value="${producto.stock}"/></span></c:otherwise>
                            </c:choose>
                        </td>
                        <td><c:out value="${nombresCategorias[producto.idCategoria]}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${producto.estado}"><span class="etiqueta etiqueta-activo">Activo</span></c:when>
                                <c:otherwise><span class="etiqueta etiqueta-inactivo">Inactivo</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="acciones">
                                <a class="boton boton-editar" href="${pageContext.request.contextPath}/productos/editar/${producto.idProducto}">Editar</a>
                                <c:if test="${producto.estado}">
                                    <form action="${pageContext.request.contextPath}/productos/desactivar/${producto.idProducto}" method="post">
                                        <c:if test="${not empty _csrf}">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                        </c:if>
                                        <button class="boton boton-desactivar" type="submit">Desactivar</button>
                                    </form>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty productos}">
                    <tr><td colspan="8" class="sin-productos">Todavía no hay productos registrados.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </section>
</main>
<%@ include file="../admin/pie.jsp" %>
</body>
</html>
