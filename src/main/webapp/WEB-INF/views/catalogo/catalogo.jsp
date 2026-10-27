
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo - Mi Pastelería</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body>

<header class="cabecera">
    <div class="logo">
        <h1>
            Mi Pastelería
            <c:choose>
                <c:when test="${esAdministrador}">
                    <span class="rol">Administrador</span>
                </c:when>
                <c:when test="${sessionScope.idRol eq 2}">
                    <span class="rol">Cliente</span>
                </c:when>
                <c:when test="${sessionScope.idRol eq 3}">
                    <span class="rol">Cajero</span>
                </c:when>
                <c:when test="${sessionScope.idRol eq 4}">
                    <span class="rol">Repartidor</span>
                </c:when>
            </c:choose>
        </h1>
        <p>Endulzamos tus mejores momentos</p>
    </div>

    <nav class="menu" aria-label="Menú principal">
        <a class="activo" href="${pageContext.request.contextPath}/catalogo">Catálogo</a>
        <a href="${pageContext.request.contextPath}/publicidad">Promociones</a>
        <a href="${pageContext.request.contextPath}/contacto">Contacto</a>
        <a href="${pageContext.request.contextPath}/carrito">Carrito</a>

        <c:if test="${not empty sessionScope.idUsuario}">
            <a href="${pageContext.request.contextPath}/pedido/historial">Mis pedidos</a>
            <a href="${pageContext.request.contextPath}/pedido/seguimiento">Seguimiento</a>
        </c:if>

        <c:if test="${esAdministrador}">
            <details class="menu-administracion">
                <summary>
                    ⚙ Administración
                    <span aria-hidden="true">▾</span>
                </summary>

                <div class="menu-administracion-opciones">
                    <a href="${pageContext.request.contextPath}/productos">Administrar productos</a>
                    <a href="${pageContext.request.contextPath}/categorias">Administrar categorías</a>
                    <a href="${pageContext.request.contextPath}/admin/promociones">Administrar promociones</a>
                    <a href="${pageContext.request.contextPath}/admin/mensajes">Mensajes de contacto</a>
                    <a href="${pageContext.request.contextPath}/admin/pedidos">Gestionar pedidos</a>
                    <a href="${pageContext.request.contextPath}/admin/usuarios">Gestionar usuarios</a>
                    <a href="${pageContext.request.contextPath}/admin/estadisticas">Resumen</a>
                </div>
            </details>
        </c:if>

        <c:if test="${not empty sessionScope.idUsuario and sessionScope.idRol eq 3}">
            <a href="${pageContext.request.contextPath}/cajero/panel">Panel del cajero</a>
        </c:if>

        <c:if test="${not empty sessionScope.idUsuario and sessionScope.idRol eq 4}">
            <a href="${pageContext.request.contextPath}/repartidor/panel">Panel del repartidor</a>
        </c:if>

        <c:choose>
            <c:when test="${not empty sessionScope.idUsuario}">
                <span class="nombre-usuario">
                    Hola, <c:out value="${sessionScope.nombreUsuario}"/>
                </span>

                <form action="${pageContext.request.contextPath}/usuario/logout" method="post">
                    <c:if test="${not empty _csrf}">
                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}">
                    </c:if>

                    <button type="submit">Cerrar sesión</button>
                </form>
            </c:when>

            <c:otherwise>
                <a href="${pageContext.request.contextPath}/usuario/login">Iniciar sesión</a>
                <a class="salir" href="${pageContext.request.contextPath}/usuario/registro">Registrarse</a>
            </c:otherwise>
        </c:choose>
    </nav>
</header>

<main class="contenido">

    <section class="titulo-seccion">
        <h2>Nuestro catálogo</h2>
        <p>
            Descubre nuestras tortas, cupcakes, galletas y postres.
            Precios y stock actualizados.
        </p>
    </section>

    <form class="tarjeta form-linea"
          action="${pageContext.request.contextPath}/catalogo"
          method="get">

        <div class="campo">
            <label for="buscar">Buscar por nombre</label>

            <input type="search"
                   id="buscar"
                   name="buscar"
                   placeholder="Ej. torta de chocolate"
                   value="<c:out value='${buscar}'/>">
        </div>

        <div class="campo">
            <label for="categoria">Categoría</label>

            <select id="categoria" name="categoria">
                <option value="">Todas las categorías</option>

                <c:forEach var="cat" items="${categorias}">
                    <option value="${cat.idCategoria}"
                            <c:if test="${idCategoriaSeleccionada eq cat.idCategoria}">
                                selected="selected"
                            </c:if>>
                        <c:out value="${cat.nombre}"/>
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="campo-check">
            <input type="checkbox"
                   id="disponibles"
                   name="disponibles"
                   value="true"
                   <c:if test="${disponibles}">checked="checked"</c:if>>

            <label for="disponibles">Solo disponibles</label>
        </div>

        <button type="submit">Filtrar</button>

        <a class="boton boton-secundario"
           href="${pageContext.request.contextPath}/catalogo">
            Limpiar
        </a>
    </form>

    <p class="resultados">
        Productos encontrados:
        <strong>
            <c:out value="${fn:length(productos)}"/>
        </strong>
    </p>

    <section class="grid-productos" aria-label="Productos del catálogo">

        <c:forEach var="producto" items="${productos}">

            <article class="producto">

                <c:choose>
                    <c:when test="${not empty producto.imagen}">
                        <c:url var="rutaImagen" value="/imagenes/${producto.imagen}"/>

                        <img class="foto"
                             src="<c:out value='${rutaImagen}'/>"
                             alt="<c:out value='${producto.nombre}'/>"
                             loading="lazy">
                    </c:when>

                    <c:otherwise>
                        <img class="foto"
                             src="${pageContext.request.contextPath}/imagenes/sin-imagen.jpg"
                             alt="Imagen no disponible"
                             loading="lazy">
                    </c:otherwise>
                </c:choose>

                <h3>
                    <c:out value="${producto.nombre}"/>
                </h3>

                <p class="descripcion">
                    <c:out value="${producto.descripcion}"/>
                </p>

                <p class="precio">
                    S/ <c:out value="${producto.precio}"/>
                </p>

                <c:choose>
                    <c:when test="${producto.stock gt 0}">

                        <p class="stock">
                            Disponible:
                            <c:out value="${producto.stock}"/>
                        </p>

                        <form action="${pageContext.request.contextPath}/carrito/agregar"
                              method="post">

                            <input type="hidden"
                                   name="idProducto"
                                   value="${producto.idProducto}">

                            <input type="hidden"
                                   name="cantidad"
                                   value="1">

                            <c:if test="${not empty _csrf}">
                                <input type="hidden"
                                       name="${_csrf.parameterName}"
                                       value="${_csrf.token}">
                            </c:if>

                            <button type="submit">
                                Agregar al carrito
                            </button>
                        </form>

                    </c:when>

                    <c:otherwise>
                        <p class="stock agotado">Agotado</p>

                        <button type="button" disabled>
                            No disponible
                        </button>
                    </c:otherwise>
                </c:choose>

            </article>

        </c:forEach>

    </section>

    <c:if test="${empty productos}">
        <div class="sin-productos">
            <h3>No encontramos productos</h3>

            <p>
                No hay productos que coincidan con los filtros seleccionados.
            </p>

            <a class="boton boton-secundario"
               href="${pageContext.request.contextPath}/catalogo">
                Mostrar todos los productos
            </a>
        </div>
    </c:if>

</main>

<footer class="pie">
    Mi Pastelería · Productos hechos con cariño
</footer>

</body>
</html>
