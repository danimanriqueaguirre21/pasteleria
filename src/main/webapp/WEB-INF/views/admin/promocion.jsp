<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${empty promocion.idPromocion}">Registrar promoción</c:when>
            <c:otherwise>Editar promoción</c:otherwise>
        </c:choose>
        | Mi Pastelería
    </title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="pagina-formulario-categoria">

<c:set var="tituloAdmin" value="Registrar promoción"/>
<c:if test="${not empty promocion.idPromocion}">
    <c:set var="tituloAdmin" value="Editar promoción"/>
</c:if>
<c:set var="menuActivo" value="promociones"/>
<%@ include file="menu.jsp" %>

<main class="contenedor-categoria">
    <div class="tarjeta-formulario">
        <div class="cabecera-formulario">
            <span class="etiqueta-seccion">GESTIÓN DE PROMOCIONES</span>
            <h1>
                <c:choose>
                    <c:when test="${empty promocion.idPromocion}">Registrar promoción</c:when>
                    <c:otherwise>Editar promoción</c:otherwise>
                </c:choose>
            </h1>
            <p class="descripcion-formulario">
                El título y la descripción son lo que verá el cliente.
            </p>
        </div>

        <form action="${pageContext.request.contextPath}/admin/promociones/guardar" method="post">
            <input type="hidden" name="idPromocion" value="${promocion.idPromocion}">

            <c:if test="${not empty _csrf}">
                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}">
            </c:if>

            <div class="campo">
                <label for="titulo">
                    Título
                    <span class="requerido">*</span>
                </label>
                <input type="text"
                       id="titulo"
                       name="titulo"
                       value="<c:out value='${promocion.titulo}'/>"
                       maxlength="100"
                       placeholder="Ejemplo: Cupcakes de fresa"
                       required>
            </div>

            <div class="campo">
                <label for="descripcion">Descripción</label>
                <textarea id="descripcion"
                          name="descripcion"
                          maxlength="255"
                          rows="4"
                          placeholder="Cuenta en qué consiste la promoción"><c:out value="${promocion.descripcion}"/></textarea>
                <small>Máximo 255 caracteres.</small>
            </div>

            <div class="campo">
                <label for="imagen">Imagen</label>
                <input type="text"
                       id="imagen"
                       name="imagen"
                       value="<c:out value='${promocion.imagen}'/>"
                       maxlength="255"
                       placeholder="promo-pasteleria.jpg">
                <small>
                    Escribe el nombre del archivo que está en la carpeta imagenes.
                    Puedes usar promo-pasteleria.jpg, cupcake-fresa.jpg o galleta.jpg.
                </small>
            </div>

            <div class="campo">
                <label for="estado">Estado</label>
                <select id="estado" name="estado">
                    <option value="true"
                        ${empty promocion.idPromocion || promocion.estado ? 'selected' : ''}>
                        Activo
                    </option>
                    <option value="false"
                        ${not empty promocion.idPromocion && !promocion.estado ? 'selected' : ''}>
                        Inactivo
                    </option>
                </select>
            </div>

            <div class="acciones-formulario">
                <a class="boton-cancelar"
                   href="${pageContext.request.contextPath}/admin/promociones">
                    Cancelar
                </a>
                <button class="boton-guardar" type="submit">
                    <c:choose>
                        <c:when test="${empty promocion.idPromocion}">Guardar promoción</c:when>
                        <c:otherwise>Actualizar promoción</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </form>
    </div>
</main>
</body>
</html>
