
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
                <c:when test="${sessionScope.rol eq 'ADMINISTRADOR'}">
                    <span class="rol">Administrador</span>
                </c:when>

                <c:when test="${sessionScope.rol eq 'CLIENTE'}">
                    <span class="rol">Cliente</span>
                </c:when>

                <c:when test="${sessionScope.rol eq 'CAJERO'}">
                    <span class="rol">Cajero</span>
                </c:when>

                <c:when test="${sessionScope.rol eq 'REPARTIDOR'}">
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

        <a href="${pageContext.request.contextPath}/pedido/historial">
            Mis pedidos
        </a>

        <a href="${pageContext.request.contextPath}/pedido/seguimiento">
            Seguimiento
        </a>

        
        <c:if test="${sessionScope.rol eq 'ADMINISTRADOR'}">
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

        
        <c:if test="${sessionScope.rol eq 'CAJERO'}">
            <a href="${pageContext.request.contextPath}/cajero/panel">
                Panel del cajero
            </a>
        </c:if>

        
        <c:if test="${sessionScope.rol eq 'REPARTIDOR'}">
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

    <section class="aviso-principal">
        <img src="${pageContext.request.contextPath}/imagenes/promo-pasteleria.jpg"
             alt="Torta decorada para una celebración">
        <div class="aviso-texto">
            <span class="etiqueta-oferta">Esta semana</span>
            <h2>Tortas para tu celebración</h2>
            <p>Pide con anticipación y recógela en tienda. Cada torta se prepara el mismo día.</p>
            <a class="boton-publicidad" href="${pageContext.request.contextPath}/catalogo">Ver el catálogo</a>
        </div>
    </section>

    <section class="rejilla-ofertas" aria-label="Ofertas de la pastelería">
        <article class="oferta-fija">
            <img src="${pageContext.request.contextPath}/imagenes/torta-chocolate.jpg"
                 alt="Torta de chocolate">
            <div class="texto-promocion">
                <span class="etiqueta-oferta">Torta</span>
                <h3>Chocolate</h3>
                <p>Cubierta de chocolate, para cumpleaños y reuniones.</p>
            </div>
        </article>

        <article class="oferta-fija">
            <img src="${pageContext.request.contextPath}/imagenes/cupcake-fresa.jpg"
                 alt="Cupcakes de fresa">
            <div class="texto-promocion">
                <span class="etiqueta-oferta">Para compartir</span>
                <h3>Cupcakes de fresa</h3>
                <p>Caja lista para llevar a una reunión.</p>
            </div>
        </article>

        <article class="oferta-fija">
            <img src="${pageContext.request.contextPath}/imagenes/galleta.jpg"
                 alt="Galletas de mantequilla">
            <div class="texto-promocion">
                <span class="etiqueta-oferta">Detalle</span>
                <h3>Galletas de mantequilla</h3>
                <p>Para acompañar el café o regalar.</p>
            </div>
        </article>
    </section>

</main>

<footer class="pie">
    Mi Pastelería · Productos hechos con cariño
</footer>

</body>
</html>
