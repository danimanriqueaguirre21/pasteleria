<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Panel del Repartidor - Mi Pastelería</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="vista-repartidor">

<header class="cabecera-repartidor">

    <h1>Panel del Repartidor</h1>

    <p>
        Bienvenido,
        <c:out value="${sessionScope.nombreUsuario}"/>
    </p>

    <div class="acciones-header">

        <a href="${pageContext.request.contextPath}/catalogo">
            Ver catálogo
        </a>

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

    </div>

</header>

<main class="contenedor">

    <c:if test="${not empty mensaje}">
        <div class="alerta alerta-exito">
            <c:out value="${mensaje}"/>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alerta alerta-error">
            <c:out value="${error}"/>
        </div>
    </c:if>

    <section class="resumen">

        <div class="tarjeta">
            <h3>📦 Pedidos asignados</h3>
            <div class="numero asignado">
                <c:out value="${asignados}"/>
            </div>
        </div>

        <div class="tarjeta">
            <h3>🚚 Pedidos en camino</h3>
            <div class="numero camino">
                <c:out value="${enCamino}"/>
            </div>
        </div>

        <div class="tarjeta">
            <h3>✅ Pedidos entregados</h3>
            <div class="numero entregado">
                <c:out value="${entregados}"/>
            </div>
        </div>

        <div class="tarjeta">
            <h3>📋 Total de pedidos</h3>
            <div class="numero total">
                <c:out value="${totalPedidos}"/>
            </div>
        </div>

    </section>

    <section class="panel">

        <h2>Mis entregas asignadas</h2>

        <p>
            Consulta los pedidos que te asignaron.
            Cuando salgas a entregar un pedido,
            presiona <strong>Recoger pedido</strong>.
            Después de entregarlo al cliente,
            presiona <strong>Confirmar entrega</strong>.
        </p>

        <div class="tabla-contenedor">

            <table>

                <thead>
                <tr>
                    <th>Pedido</th>
                    <th>Código de seguimiento</th>
                    <th>Cliente</th>
                    <th>Dirección de entrega</th>
                    <th>Teléfono</th>
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
                            <c:choose>
                                <c:when test="${not empty pedido.codigoSeguimiento}">
                                    <span class="codigo-seguimiento">
                                        <c:out value="${pedido.codigoSeguimiento}"/>
                                    </span>
                                </c:when>

                                <c:otherwise>
                                    <span class="sin-codigo">
                                        No disponible
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${not empty nombresClientes[pedido.idUsuario]}">
                                    <c:out value="${nombresClientes[pedido.idUsuario]}"/>
                                </c:when>

                                <c:otherwise>
                                    Usuario #<c:out value="${pedido.idUsuario}"/>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="direccion">
                            <c:out value="${pedido.direccionEntrega}"/>
                        </td>

                        <td>
                            <c:out value="${pedido.telefono}"/>
                        </td>

                        <td>
                            S/ <c:out value="${pedido.total}"/>
                        </td>

                        <td>
                            <c:out value="${pedido.medioPago}"/>
                        </td>

                        <td>

                            <c:choose>

                                <c:when test="${pedido.estado eq 'ASIGNADO'}">
                                    <span class="estado asignado">
                                        Asignado
                                    </span>
                                </c:when>

                                <c:when test="${pedido.estado eq 'EN CAMINO'}">
                                    <span class="estado camino">
                                        En camino
                                    </span>
                                </c:when>

                                <c:when test="${pedido.estado eq 'ENTREGADO'}">
                                    <span class="estado entregado">
                                        Entregado
                                    </span>
                                </c:when>

                                <c:otherwise>
                                    <c:out value="${pedido.estado}"/>
                                </c:otherwise>

                            </c:choose>

                        </td>

                        <td>

                            <div class="acciones-pedido">

                                <c:choose>

                                    
                                    <c:when test="${pedido.estado eq 'ASIGNADO'}">

                                        <form class="form-entrega"
                                              action="${pageContext.request.contextPath}/repartidor/iniciar-reparto"
                                              method="post">

                                            <input type="hidden"
                                                   name="idPedido"
                                                   value="${pedido.idPedido}">

                                            <c:if test="${not empty _csrf}">
                                                <input type="hidden"
                                                       name="${_csrf.parameterName}"
                                                       value="${_csrf.token}">
                                            </c:if>

                                            <button class="boton boton-iniciar"
                                                    type="submit">
                                                📦 Recoger pedido
                                            </button>

                                        </form>

                                    </c:when>

                                    
                                    <c:when test="${pedido.estado eq 'EN CAMINO'}">

                                        <form class="form-entrega"
                                              action="${pageContext.request.contextPath}/repartidor/confirmar-entrega"
                                              method="post">

                                            <input type="hidden"
                                                   name="idPedido"
                                                   value="${pedido.idPedido}">

                                            <c:if test="${not empty _csrf}">
                                                <input type="hidden"
                                                       name="${_csrf.parameterName}"
                                                       value="${_csrf.token}">
                                            </c:if>

                                            <button class="boton boton-entregar"
                                                    type="submit">
                                                ✅ Confirmar entrega
                                            </button>

                                        </form>

                                    </c:when>

                                    
                                    <c:when test="${pedido.estado eq 'ENTREGADO'}">

                                        <span class="entrega-completada">
                                            ✓ Entrega completada
                                        </span>

                                    </c:when>

                                    <c:otherwise>
                                        <span>
                                            Sin acciones disponibles
                                        </span>
                                    </c:otherwise>

                                </c:choose>

                            </div>

                        </td>

                    </tr>

                </c:forEach>

                <c:if test="${empty pedidos}">
                    <tr>
                        <td colspan="9" class="sin-pedidos">
                            Todavía no tienes pedidos asignados.
                        </td>
                    </tr>
                </c:if>

                </tbody>

            </table>

        </div>

    </section>

</main>

</body>
</html>