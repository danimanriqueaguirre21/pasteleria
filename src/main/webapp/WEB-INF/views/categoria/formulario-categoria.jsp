
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>
        <c:choose>
            <c:when test="${empty categoria.idCategoria}">
                Registrar categoría
            </c:when>
            <c:otherwise>
                Editar categoría
            </c:otherwise>
        </c:choose>
        | Mi Pastelería
    </title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="pagina-formulario-categoria">

<c:set var="tituloAdmin" value="Registrar categoría"/>
<c:if test="${not empty categoria.idCategoria}">
    <c:set var="tituloAdmin" value="Editar categoría"/>
</c:if>
<c:set var="menuActivo" value="categorias"/>
<%@ include file="../admin/menu.jsp" %>

<main class="contenedor-categoria">

    <div class="tarjeta-formulario">

        <div class="cabecera-formulario">

            <span class="etiqueta-seccion">
                GESTIÓN DE CATEGORÍAS
            </span>

            <h1>
                <c:choose>
                    <c:when test="${empty categoria.idCategoria}">
                        Registrar categoría
                    </c:when>
                    <c:otherwise>
                        Editar categoría
                    </c:otherwise>
                </c:choose>
            </h1>

            <p class="descripcion-formulario">
                Completa la información de la categoría de productos.
            </p>

        </div>

        <c:if test="${not empty error}">
            <p class="error"><c:out value="${error}"/></p>
        </c:if>

        <form action="${pageContext.request.contextPath}/categorias/guardar"
              method="post">

            
            <input type="hidden"
                   name="idCategoria"
                   value="${categoria.idCategoria}">

            
            <c:if test="${not empty _csrf}">
                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}">
            </c:if>

            
            <div class="campo">

                <label for="nombre">
                    Nombre de la categoría
                    <span class="requerido">*</span>
                </label>

                <input type="text"
                       id="nombre"
                       name="nombre"
                       value="<c:out value='${categoria.nombre}'/>"
                       maxlength="100"
                       placeholder="Ejemplo: Tortas"
                       required>

            </div>

            
            <div class="campo">

                <label for="descripcion">
                    Descripción
                </label>

                <textarea id="descripcion"
                          name="descripcion"
                          maxlength="255"
                          rows="4"
                          placeholder="Describe brevemente la categoría"><c:out value="${categoria.descripcion}"/></textarea>

                <small>Máximo 255 caracteres.</small>

            </div>

            
            <div class="campo">

                <label for="estado">
                    Estado
                </label>

                <select id="estado" name="estado">

                    <option value="true"
                        ${empty categoria.idCategoria || categoria.estado ? 'selected' : ''}>
                        Activo
                    </option>

                    <option value="false"
                        ${not empty categoria.idCategoria && !categoria.estado ? 'selected' : ''}>
                        Inactivo
                    </option>

                </select>

            </div>

            
            <div class="acciones-formulario">

                <a class="boton-cancelar"
                   href="${pageContext.request.contextPath}/categorias">
                    Cancelar
                </a>

                <button class="boton-guardar"
                        type="submit">

                    <c:choose>
                        <c:when test="${empty categoria.idCategoria}">
                            Guardar categoría
                        </c:when>
                        <c:otherwise>
                            Actualizar categoría
                        </c:otherwise>
                    </c:choose>

                </button>

            </div>

        </form>

    </div>

</main>

</body>
</html>
