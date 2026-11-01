
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Mis pedidos - Mi Pastelería</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="historial-pagina">

<header class="cabecera">

    <div class="logo">
        <h1>
            Mi Pastelería

            <c:choose>
                <c:when test="${esAdministrador}">
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

<main class="contenido contenedor">

    <h2>Mis pedidos</h2>

    <p class="descripcion">
        Hola,
        <strong>
            <c:out value="${sessionScope.nombreUsuario}"/>
        </strong>.
        Aquí puedes consultar tus pedidos registrados y cancelar
        aquellos que todavía estén en estado RECIBIDO.
    </p>

    
    <c:if test="${not empty mensaje}">
        <div class="mensaje mensaje-exito" role="status">
            <c:out value="${mensaje}"/>
        </div>
    </c:if>

    
    <c:if test="${not empty error}">
        <div class="mensaje mensaje-error" role="alert">
            <c:out value="${error}"/>
        </div>
    </c:if>

    <c:choose>

        
        <c:when test="${empty pedidos}">

            <div class="vacio">

                <h3>Todavía no tienes pedidos</h3>

                <p>
                    Explora nuestro catálogo y realiza tu primera compra.
                </p>

                <a class="boton"
                   href="${pageContext.request.contextPath}/catalogo">
                    Ver productos
                </a>

            </div>

        </c:when>

        
        <c:otherwise>

            <div class="tabla-contenedor">
                <table>

                    <thead>
                        <tr>
                            <th>N.º pedido</th>
                            <th>Fecha</th>
                            <th>Dirección de entrega</th>
                            <th>Total</th>
                            <th>Medio de pago</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>

                    <tbody>

                        <c:forEach var="pedido" items="${pedidos}">

                            <tr>

                                <td>
                                    #<c:out value="${pedido.idPedido}"/>
                                </td>

                                <td>
                                    <c:out value="${pedido.fechaPedidoTexto}"/>
                                </td>

                                <td>
                                    <c:out value="${pedido.direccionEntrega}"/>
                                </td>

                                <td class="total">
                                    S/ <c:out value="${pedido.total}"/>
                                </td>

                                
                                <td>

                                    <c:choose>

                                        <c:when test="${pedido.medioPago eq 'YAPE'}">
                                            <span class="medio-pago yape">
                                                📱 Yape
                                            </span>
                                        </c:when>

                                        <c:when test="${pedido.medioPago eq 'PLIN'}">
                                            <span class="medio-pago plin">
                                                📲 Plin
                                            </span>
                                        </c:when>

                                        <c:when test="${pedido.medioPago eq 'TARJETA'}">
                                            <span class="medio-pago tarjeta">
                                                💳 Tarjeta
                                            </span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="medio-pago sin-registro">
                                                Sin medio de pago
                                            </span>
                                        </c:otherwise>

                                    </c:choose>

                                </td>

                                
                                <td>

                                    <c:choose>

                                        <c:when test="${pedido.estado eq 'RECIBIDO'}">
                                            <span class="estado recibido">
                                                RECIBIDO
                                            </span>
                                        </c:when>

                                        <c:when test="${pedido.estado eq 'EN PREPARACIÓN'}">
                                            <span class="estado preparacion">
                                                EN PREPARACIÓN
                                            </span>
                                        </c:when>

                                        <c:when test="${pedido.estado eq 'LISTO'}">
                                            <span class="estado listo">
                                                LISTO
                                            </span>
                                        </c:when>

                                        <c:when test="${pedido.estado eq 'ASIGNADO'}">
                                            <span class="estado asignado">
                                                ASIGNADO
                                            </span>
                                        </c:when>

                                        <c:when test="${pedido.estado eq 'EN CAMINO'}">
                                            <span class="estado camino">
                                                EN CAMINO
                                            </span>
                                        </c:when>

                                        <c:when test="${pedido.estado eq 'ENTREGADO'}">
                                            <span class="estado entregado">
                                                ENTREGADO
                                            </span>
                                        </c:when>

                                        <c:when test="${pedido.estado eq 'CANCELADO'}">
                                            <span class="estado cancelado">
                                                CANCELADO
                                            </span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="estado">
                                                <c:out value="${pedido.estado}"/>
                                            </span>
                                        </c:otherwise>

                                    </c:choose>

                                </td>

                                
                                <td>

                                    <div class="acciones-pedido">

                                        <c:url var="urlDetalle"
                                               value="/pedido/detalle">
                                            <c:param name="id"
                                                     value="${pedido.idPedido}"/>
                                        </c:url>

                                        <a class="boton boton-detalle"
                                           href="<c:out value='${urlDetalle}'/>">
                                            Ver detalle
                                        </a>

                                        <c:if test="${pedido.estado eq 'RECIBIDO'}">

                                            <form action="${pageContext.request.contextPath}/pedido/cancelar"
                                                  method="post"
                                                  onsubmit="return confirmarCancelacion();">

                                                <input type="hidden"
                                                       name="idPedido"
                                                       value="${pedido.idPedido}">

                                                <c:if test="${not empty _csrf}">
                                                    <input type="hidden"
                                                           name="${_csrf.parameterName}"
                                                           value="${_csrf.token}">
                                                </c:if>

                                                <button type="submit"
                                                        class="boton boton-cancelar">
                                                    Cancelar pedido
                                                </button>

                                            </form>

                                        </c:if>

                                    </div>

                                </td>

                            </tr>

                        </c:forEach>

                    </tbody>

                </table>
            </div>

        </c:otherwise>

    </c:choose>

    <div class="acciones">
        <a class="boton"
           href="${pageContext.request.contextPath}/catalogo">
            Volver al catálogo
        </a>
    </div>

</main>

<footer class="pie">
    Mi Pastelería · Productos hechos con cariño
</footer>

<script>
    function confirmarCancelacion() {
        return window.confirm(
            "¿Estás seguro de que deseas cancelar este pedido?\n\n" +
            "El pedido cambiará a CANCELADO y los productos " +
            "volverán al inventario.\n\n" +
            "Esta acción no se puede deshacer."
        );
    }
</script>

</body>
</html>
