
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>
        <c:choose>
            <c:when test="${producto.idProducto == null}">
                Registrar producto
            </c:when>
            <c:otherwise>
                Editar producto
            </c:otherwise>
        </c:choose>
        | Mi Pastelería
    </title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="pagina-formulario-producto">

<c:set var="tituloAdmin" value="Registrar producto"/>
<c:if test="${producto.idProducto != null}">
    <c:set var="tituloAdmin" value="Editar producto"/>
</c:if>
<c:set var="menuActivo" value="productos"/>
<%@ include file="../admin/menu.jsp" %>

<main class="contenedor-producto">

    <div class="tarjeta-formulario">

        <div class="cabecera-formulario">

            <span class="etiqueta-seccion">
                GESTIÓN DE PRODUCTOS
            </span>

            <h1>
                <c:choose>
                    <c:when test="${producto.idProducto == null}">
                        Registrar producto
                    </c:when>
                    <c:otherwise>
                        Editar producto
                    </c:otherwise>
                </c:choose>
            </h1>

            <p>
                Completa los datos del producto para
                guardarlo en el catálogo.
            </p>

        </div>

        <c:if test="${not empty error}">
            <p class="error"><c:out value="${error}"/></p>
        </c:if>

        <form action="${pageContext.request.contextPath}/productos/guardar"
              method="post">

            
            <input type="hidden"
                   name="idProducto"
                   value="${producto.idProducto}">

            
            <c:if test="${not empty _csrf}">
                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}">
            </c:if>

            
            <div class="campo">

                <label for="nombre">
                    Nombre del producto
                    <span class="requerido">*</span>
                </label>

                <input
                    id="nombre"
                    type="text"
                    name="nombre"
                    value="<c:out value='${producto.nombre}'/>"
                    maxlength="100"
                    placeholder="Ejemplo: Torta de chocolate"
                    required>

            </div>

            
            <div class="campo">

                <label for="descripcion">
                    Descripción
                </label>

                <textarea
                    id="descripcion"
                    name="descripcion"
                    maxlength="255"
                    rows="3"
                    placeholder="Describe brevemente el producto"><c:out value="${producto.descripcion}"/></textarea>

            </div>

            
            <div class="campos-dos-columnas">

                <div class="campo">

                    <label for="precio">
                        Precio (S/)
                        <span class="requerido">*</span>
                    </label>

                    <input
                        id="precio"
                        type="number"
                        name="precio"
                        value="${producto.precio}"
                        min="0.01"
                        step="0.01"
                        placeholder="0.00"
                        required>

                </div>

                <div class="campo">

                    <label for="stock">
                        Stock
                        <span class="requerido">*</span>
                    </label>

                    <input
                        id="stock"
                        type="number"
                        name="stock"
                        value="${producto.stock}"
                        min="0"
                        step="1"
                        placeholder="0"
                        required>

                </div>

            </div>

            
            <div class="campo">

                <label for="imagen">
                    Imagen (nombre o ruta)
                </label>

                <input
                    id="imagen"
                    type="text"
                    name="imagen"
                    value="<c:out value='${producto.imagen}'/>"
                    placeholder="Ejemplo: torta-chocolate.jpg"
                    maxlength="255">

                <small>
                    Ingresa el nombre o la ruta de la imagen
                    registrada en tu proyecto.
                </small>

            </div>

            
            <div class="campos-dos-columnas">

                <div class="campo">

                    <label for="idCategoria">
                        Categoría
                        <span class="requerido">*</span>
                    </label>

                    <select
                        id="idCategoria"
                        name="idCategoria"
                        required>

                        <option value="">
                            Seleccione una categoría
                        </option>

                        <c:forEach var="categoria"
                                   items="${categorias}">

                            <c:if test="${categoria.estado || categoria.idCategoria == producto.idCategoria}">

                                <option
                                    value="${categoria.idCategoria}"
                                    ${categoria.idCategoria == producto.idCategoria ? 'selected' : ''}>

                                    <c:out value="${categoria.nombre}"/>

                                </option>

                            </c:if>

                        </c:forEach>

                    </select>

                </div>

                <div class="campo">

                    <label for="estado">
                        Estado
                    </label>

                    <select id="estado" name="estado">

                        <option
                            value="true"
                            ${producto.idProducto == null || producto.estado ? 'selected' : ''}>
                            Activo
                        </option>

                        <option
                            value="false"
                            ${producto.idProducto != null && !producto.estado ? 'selected' : ''}>
                            Inactivo
                        </option>

                    </select>

                </div>

            </div>

            
            <div class="acciones-formulario">

                <a class="boton-cancelar"
                   href="${pageContext.request.contextPath}/productos">
                    Cancelar
                </a>

                <button class="boton-guardar"
                        type="submit">
                    Guardar producto
                </button>

            </div>

        </form>

    </div>

</main>

</body>
</html>
