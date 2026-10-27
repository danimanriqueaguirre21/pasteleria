
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Promociones - Mi Pastelería</title>

    

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="pagina-promociones">

<header class="cabecera">

    <div class="logo">
        <h1>
            Mi Pastelería

            <c:choose>
                <c:when test="${sessionScope.idRol eq 1}">
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

        <a href="${pageContext.request.contextPath}/catalogo">
            Catálogo
        </a>

        <a class="activo"
           aria-current="page"
           href="${pageContext.request.contextPath}/publicidad">
            Promociones
        </a>

        <a href="${pageContext.request.contextPath}/contacto">
            Contacto
        </a>

        <a href="${pageContext.request.contextPath}/carrito">
            Carrito
        </a>

        
        <c:if test="${not empty sessionScope.idUsuario}">
            <a href="${pageContext.request.contextPath}/pedido/historial">
                Mis pedidos
            </a>

            <a href="${pageContext.request.contextPath}/pedido/seguimiento">
                Seguimiento
            </a>
        </c:if>

        
        <c:if test="${sessionScope.idRol eq 1}">
            <details class="menu-administracion">
                <summary>
                    ⚙ Administración
                    <span aria-hidden="true">▾</span>
                </summary>

                <div class="menu-administracion-opciones">
                    <a href="${pageContext.request.contextPath}/productos">
                        Administrar productos
                    </a>

                    <a href="${pageContext.request.contextPath}/categorias">
                        Administrar categorías
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/promociones">
                        Administrar promociones
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/mensajes">
                        Mensajes de contacto
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/pedidos">
                        Gestionar pedidos
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/usuarios">
                        Gestionar usuarios
                    </a>

                    <a href="${pageContext.request.contextPath}/admin/estadisticas">
                        Resumen
                    </a>
                </div>
            </details>
        </c:if>

        
        <c:if test="${sessionScope.idRol eq 3}">
            <a href="${pageContext.request.contextPath}/cajero/panel">
                Panel del cajero
            </a>
        </c:if>

        
        <c:if test="${sessionScope.idRol eq 4}">
            <a href="${pageContext.request.contextPath}/repartidor/panel">
                Panel del repartidor
            </a>
        </c:if>

        
        <c:choose>

            <c:when test="${not empty sessionScope.idUsuario}">

                <span class="nombre-usuario">
                    Hola,
                    <c:out value="${sessionScope.nombreUsuario}"/>
                </span>

                <form action="${pageContext.request.contextPath}/usuario/logout"
                      method="post">

                    <c:if test="${not empty _csrf}">
                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}">
                    </c:if>

                    <button type="submit">
                        Cerrar sesión
                    </button>
                </form>
            </c:when>

            <c:otherwise>
                <a href="${pageContext.request.contextPath}/usuario/login">
                    Iniciar sesión
                </a>

                <a class="salir"
                   href="${pageContext.request.contextPath}/usuario/registro">
                    Registrarse
                </a>
            </c:otherwise>

        </c:choose>

    </nav>
</header>

<main class="contenido-publicidad">

    <section class="presentacion-publicidad">
        <h2>Nuestras promociones</h2>

        <p>
            Mira las ofertas de la semana y elige tu favorita en el catálogo.
        </p>
    </section>

    <c:choose>
        <c:when test="${empty promociones}">
            <p class="sin-promociones">Por ahora no hay promociones activas.</p>
        </c:when>
        <c:otherwise>
            <section class="lista-promociones" aria-label="Promociones activas">
                <c:forEach var="promocion" items="${promociones}">
                    <article class="tarjeta-promocion">
                        <c:choose>
                            <c:when test="${not empty promocion.imagen}">
                                <c:url var="rutaImagen" value="/imagenes/${promocion.imagen}"/>
                                <img src="${rutaImagen}"
                                     alt="<c:out value='${promocion.titulo}'/>">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/imagenes/sin-imagen.jpg"
                                     alt="Promoción sin imagen">
                            </c:otherwise>
                        </c:choose>

                        <div class="texto-promocion">
                            <h3><c:out value="${promocion.titulo}"/></h3>
                            <p><c:out value="${promocion.descripcion}"/></p>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:otherwise>
    </c:choose>

    <div class="accion-publicidad">
        <a class="boton-publicidad"
           href="${pageContext.request.contextPath}/catalogo">
            Ver nuestros productos
        </a>
    </div>

</main>

<footer class="pie">
    Mi Pastelería · Productos hechos con cariño
</footer>

</body>
</html>
