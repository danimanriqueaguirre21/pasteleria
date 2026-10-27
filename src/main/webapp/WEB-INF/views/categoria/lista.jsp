
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Gestión de categorías - Mi Pastelería</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="categorias-pagina">

<c:set var="tituloAdmin" value="Gestión de categorías"/>
<c:set var="menuActivo" value="categorias"/>
<%@ include file="../admin/menu.jsp" %>

<main class="contenedor">

    <div class="barra-acciones">

        <div>
            <h2>Listado de categorías</h2>
            <p>
                Consulta, edita o desactiva
                las categorías registradas.
            </p>
        </div>

        <a class="boton boton-nuevo"
           href="${pageContext.request.contextPath}/categorias/nuevo">
            + Nueva categoría
        </a>

    </div>

    <section class="panel">

        <div class="tabla-contenedor">

            <table>

                <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach var="categoria" items="${categorias}">

                    <tr>

                        <td class="identificador">
                            #<c:out value="${categoria.idCategoria}"/>
                        </td>

                        <td class="nombre">
                            <c:out value="${categoria.nombre}"/>
                        </td>

                        <td class="descripcion">
                            <c:out value="${categoria.descripcion}"/>
                        </td>

                        <td>

                            <c:choose>

                                <c:when test="${categoria.estado}">
                                    <span class="estado estado-activo">
                                        Activo
                                    </span>
                                </c:when>

                                <c:otherwise>
                                    <span class="estado estado-inactivo">
                                        Inactivo
                                    </span>
                                </c:otherwise>

                            </c:choose>

                        </td>

                        <td>

                            <div class="acciones">

                                
                                <a class="boton boton-editar"
                                   href="${pageContext.request.contextPath}/categorias/editar/${categoria.idCategoria}">
                                    Editar
                                </a>

                                
                                <c:if test="${categoria.estado}">

                                    <form
                                        action="${pageContext.request.contextPath}/categorias/desactivar/${categoria.idCategoria}"
                                        method="post">

                                        <c:if test="${not empty _csrf}">
                                            <input type="hidden"
                                                   name="${_csrf.parameterName}"
                                                   value="${_csrf.token}">
                                        </c:if>

                                        <button
                                            class="boton boton-desactivar"
                                            type="submit"
                                            onclick="return confirm('¿Deseas desactivar esta categoría?');">
                                            Desactivar
                                        </button>

                                    </form>

                                </c:if>

                            </div>

                        </td>

                    </tr>

                </c:forEach>

                
                <c:if test="${empty categorias}">

                    <tr>
                        <td colspan="5" class="sin-registros">
                            Todavía no hay categorías registradas.
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
