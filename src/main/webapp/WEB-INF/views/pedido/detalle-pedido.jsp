
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Detalle del pedido - Mi Pastelería</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

<header class="cabecera">
    <div class="logo">
        <h1>Mi Pastelería</h1>
        <p>Detalle de tu compra</p>
    </div>

    <nav class="menu" aria-label="Menú principal">

        <a href="${pageContext.request.contextPath}/catalogo">
            Catálogo
        </a>

        <a href="${pageContext.request.contextPath}/publicidad">
            Promociones
        </a>

        <a href="${pageContext.request.contextPath}/contacto">
            Contacto
        </a>

        <a href="${pageContext.request.contextPath}/carrito">
            Carrito
        </a>

        <c:if test="${not empty sessionScope.idUsuario}">

            <a class="activo"
               aria-current="page"
               href="${pageContext.request.contextPath}/pedido/historial">
                Mis pedidos
            </a>

            <a href="${pageContext.request.contextPath}/pedido/seguimiento">
                Seguimiento
            </a>

        </c:if>

        <c:if test="${esAdministrador}">
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

        <c:if test="${not empty sessionScope.idUsuario and sessionScope.rol eq 'CAJERO'}">

            <a href="${pageContext.request.contextPath}/cajero/panel">
                Panel del cajero
            </a>

        </c:if>

        <c:if test="${not empty sessionScope.idUsuario and sessionScope.rol eq 'REPARTIDOR'}">

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

<main class="contenido detalle-pagina">

    <div class="titulo-seccion">
        <h2>
            Detalle del pedido
        </h2>

        <p>Consulta la información y los productos de tu compra.</p>
    </div>

    <section class="tarjeta detalle-tarjeta"
             aria-label="Información general del pedido">

        <h3>Información del pedido</h3>

        <div class="informacion">

            <p>
                <strong>Fecha:</strong>
                <c:out value="${pedido.fechaPedidoTexto}"/>
            </p>

            <p>
                <strong>Dirección de entrega:</strong>
                <c:out value="${pedido.direccionEntrega}"/>
            </p>

            <p>
                <strong>Teléfono:</strong>
                <c:out value="${pedido.telefono}"/>
            </p>

            <p>
                <strong>Estado:</strong>

                <c:choose>
                    <c:when test="${pedido.estado eq 'RECIBIDO'}">
                        <span class="estado recibido">RECIBIDO</span>
                    </c:when>

                    <c:when test="${pedido.estado eq 'EN PREPARACIÓN'}">
                        <span class="estado preparacion">EN PREPARACIÓN</span>
                    </c:when>

                    <c:when test="${pedido.estado eq 'LISTO'}">
                        <span class="estado listo">LISTO</span>
                    </c:when>

                    <c:when test="${pedido.estado eq 'ASIGNADO'}">
                        <span class="estado asignado">ASIGNADO</span>
                    </c:when>

                    <c:when test="${pedido.estado eq 'EN CAMINO'}">
                        <span class="estado camino">EN CAMINO</span>
                    </c:when>

                    <c:when test="${pedido.estado eq 'ENTREGADO'}">
                        <span class="estado entregado">ENTREGADO</span>
                    </c:when>

                    <c:when test="${pedido.estado eq 'CANCELADO'}">
                        <span class="estado cancelado">CANCELADO</span>
                    </c:when>

                    <c:otherwise>
                        <span class="estado">
                            <c:out value="${pedido.estado}"/>
                        </span>
                    </c:otherwise>
                </c:choose>
            </p>

            <p>
                <strong>Medio de pago:</strong>

                <span class="medio-pago">
                    <c:choose>
                        <c:when test="${pedido.medioPago eq 'YAPE'}">
                            📱 Yape
                        </c:when>

                        <c:when test="${pedido.medioPago eq 'PLIN'}">
                            📲 Plin
                        </c:when>

                        <c:when test="${pedido.medioPago eq 'TARJETA'}">
                            💳 Tarjeta
                        </c:when>

                        <c:otherwise>
                            Sin medio de pago
                        </c:otherwise>
                    </c:choose>
                </span>
            </p>

            <c:if test="${not empty pedido.codigoSeguimiento}">
                <p>
                    <strong>Código de seguimiento:</strong>
                    <span class="codigo-seguimiento">
                        <c:out value="${pedido.codigoSeguimiento}"/>
                    </span>
                </p>

                <c:url var="urlSeguimiento" value="/pedido/seguimiento">
                    <c:param name="codigo" value="${pedido.codigoSeguimiento}"/>
                </c:url>

                <p>
                    <a class="boton"
                       href="<c:out value='${urlSeguimiento}'/>">
                        Consultar seguimiento
                    </a>
                </p>
            </c:if>

            <c:if test="${empty pedido.codigoSeguimiento}">
                <p class="nota-pago">
                    Este pedido no tiene un código de seguimiento registrado.
                </p>
            </c:if>

        </div>

    </section>

    <section class="tarjeta detalle-tarjeta"
             aria-label="Productos comprados">

        <h3>Productos de la compra</h3>

        <div class="tabla-contenedor">

            <table>
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Cantidad</th>
                        <th>Precio unitario</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="detalle" items="${detalles}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty detalle.nombreProducto}">
                                        <c:out value="${detalle.nombreProducto}"/>
                                    </c:when>
                                    <c:otherwise>
                                        Producto #<c:out value="${detalle.idProducto}"/>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <c:out value="${detalle.cantidad}"/>
                            </td>

                            <td>
                                S/ <c:out value="${detalle.precioUnitario}"/>
                            </td>

                            <td>
                                S/ <c:out value="${detalle.subtotal}"/>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

        </div>

        <div class="total">
            Total: S/ <c:out value="${pedido.total}"/>
        </div>

    </section>

    <a class="boton boton-volver"
       href="${pageContext.request.contextPath}/pedido/historial">
        Volver a mis pedidos
    </a>

</main>

<footer class="pie">
    Mi Pastelería - Productos hechos con cariño
</footer>

</body>
</html>
