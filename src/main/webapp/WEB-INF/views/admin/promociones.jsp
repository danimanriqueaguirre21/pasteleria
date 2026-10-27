<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de promociones - Mi Pastelería</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="categorias-pagina">

<c:set var="tituloAdmin" value="Gestión de promociones"/>
<c:set var="menuActivo" value="promociones"/>
<%@ include file="menu.jsp" %>

<main class="contenedor">

    <div class="barra-acciones">
        <div>
            <h2>Listado de promociones</h2>
            <p>
                Las promociones activas se ven en el menú Promociones.
                Las inactivas quedan guardadas, pero el cliente no las ve.
            </p>
        </div>

        <a class="boton boton-nuevo"
           href="${pageContext.request.contextPath}/admin/promociones/nuevo">
            + Nueva promoción
        </a>
    </div>

    <section class="panel">
        <div class="tabla-contenedor">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Título</th>
                    <th>Descripción</th>
                    <th>Imagen</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="promocion" items="${promociones}">
                    <tr>
                        <td class="identificador">
                            #<c:out value="${promocion.idPromocion}"/>
                        </td>
                        <td class="nombre">
                            <c:out value="${promocion.titulo}"/>
                        </td>
                        <td class="descripcion">
                            <c:out value="${promocion.descripcion}"/>
                        </td>
                        <td>
                            <c:out value="${empty promocion.imagen ? 'Sin imagen' : promocion.imagen}"/>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${promocion.estado}">
                                    <span class="estado estado-activo">Activo</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="estado estado-inactivo">Inactivo</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="acciones">
                                <a class="boton boton-editar"
                                   href="${pageContext.request.contextPath}/admin/promociones/editar/${promocion.idPromocion}">
                                    Editar
                                </a>

                                <c:if test="${promocion.estado}">
                                    <form action="${pageContext.request.contextPath}/admin/promociones/desactivar/${promocion.idPromocion}"
                                          method="post">
                                        <c:if test="${not empty _csrf}">
                                            <input type="hidden"
                                                   name="${_csrf.parameterName}"
                                                   value="${_csrf.token}">
                                        </c:if>
                                        <button class="boton boton-desactivar"
                                                type="submit"
                                                onclick="return confirm('¿Deseas ocultar esta promoción?');">
                                            Desactivar
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty promociones}">
                    <tr>
                        <td colspan="6" class="sin-registros">
                            Todavía no hay promociones registradas.
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </section>

</main>

<footer>
    Mi Pastelería · Sistema de gestión
</footer>
</body>
</html>
