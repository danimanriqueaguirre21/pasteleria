<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrar pedidos - Mi Pastelería</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body class="pagina-admin-pedidos">
<c:set var="tituloAdmin" value="Gestión de Pedidos"/>
<c:set var="menuActivo" value="pedidos"/>
<%@ include file="menu.jsp" %>
<main class="contenedor admin-pedidos-contenedor">
    <section class="panel-pedidos">
        <h2>Pedidos registrados</h2>
        <p class="descripcion">Los pedidos están separados por estado. Abre un bloque para ver solo esos pedidos. La asignación y la entrega corresponden al cajero y al repartidor.</p>
        <c:if test="${not empty mensaje}">
            <div class="mensaje" role="status"><c:out value="${mensaje}"/></div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="error" role="alert"><c:out value="${error}"/></div>
        </c:if>
        <c:set var="hayBloques" value="false"/>

        <c:forEach var="bloque" items="${bloques}">
            <c:if test="${not empty bloque.value}">
                <c:set var="hayBloques" value="true"/>

                <details class="bloque-pedido"
                         <c:if test="${bloque.key eq 'RECIBIDO' or bloque.key eq 'EN PREPARACIÓN'}">open</c:if>>
                    <summary>
                        <c:choose>
                            <c:when test="${bloque.key eq 'RECIBIDO'}">Pendientes</c:when>
                            <c:when test="${bloque.key eq 'EN PREPARACIÓN'}">En preparaci&oacute;n</c:when>
                            <c:when test="${bloque.key eq 'LISTO'}">Listos para asignar</c:when>
                            <c:when test="${bloque.key eq 'ASIGNADO'}">Asignados</c:when>
                            <c:when test="${bloque.key eq 'EN CAMINO'}">En camino</c:when>
                            <c:when test="${bloque.key eq 'ENTREGADO'}">Entregados</c:when>
                            <c:when test="${bloque.key eq 'CANCELADO'}">Cancelados</c:when>
                            <c:otherwise><c:out value="${bloque.key}"/></c:otherwise>
                        </c:choose>
                        (<c:out value="${fn:length(bloque.value)}"/>)
                    </summary>

                    <div class="tabla-contenedor">
                        <table>
                            <thead>
                            <tr>
                                <th scope="col">N.º pedido</th>
                                <th scope="col">Cliente</th>
                                <th scope="col">Productos</th>
                                <th scope="col">Fecha</th>
                                <th scope="col">Dirección</th>
                                <th scope="col">Teléfono</th>
                                <th scope="col">Total</th>
                                <th scope="col">Medio de pago</th>
                                <th scope="col">Estado actual</th>
                                <th scope="col">Actualizar estado</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="pedido" items="${bloque.value}">
                            <tr>
                                <td>#<c:out value="${pedido.idPedido}"/></td>
                                <td><c:out value="${nombresClientes[pedido.idUsuario]}"/></td>
                                <td>
                                    <c:out value="${empty resumenProductos[pedido.idPedido] ? 'Sin productos' : resumenProductos[pedido.idPedido]}"/>
                                </td>
                                <td><c:out value="${pedido.fechaPedido}"/></td>
                                <td><c:out value="${pedido.direccionEntrega}"/></td>
                                <td><c:out value="${pedido.telefono}"/></td>
                                <td class="precio">S/ <c:out value="${pedido.total}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${pedido.medioPago eq 'EFECTIVO'}"><span class="medio-pago efectivo">Efectivo</span></c:when>
                                        <c:when test="${pedido.medioPago eq 'YAPE'}"><span class="medio-pago yape">Yape</span></c:when>
                                        <c:when test="${pedido.medioPago eq 'PLIN'}"><span class="medio-pago plin">Plin</span></c:when>
                                        <c:when test="${pedido.medioPago eq 'TARJETA'}"><span class="medio-pago tarjeta">Tarjeta</span></c:when>
                                        <c:otherwise><span class="medio-pago sin-registro">Sin medio de pago</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${pedido.estado eq 'RECIBIDO'}"><span class="estado pendiente">RECIBIDO</span></c:when>
                                        <c:when test="${pedido.estado eq 'PENDIENTE'}"><span class="estado pendiente">PENDIENTE</span></c:when>
                                        <c:when test="${pedido.estado eq 'EN PREPARACIÓN'}"><span class="estado preparacion">EN PREPARACIÓN</span></c:when>
                                        <c:when test="${pedido.estado eq 'LISTO'}"><span class="estado listo">LISTO</span></c:when>
                                        <c:when test="${pedido.estado eq 'ASIGNADO'}"><span class="estado asignado">ASIGNADO</span></c:when>
                                        <c:when test="${pedido.estado eq 'EN CAMINO'}"><span class="estado camino">EN CAMINO</span></c:when>
                                        <c:when test="${pedido.estado eq 'EN REPARTO'}"><span class="estado camino">EN REPARTO</span></c:when>
                                        <c:when test="${pedido.estado eq 'ENTREGADO'}"><span class="estado entregado">ENTREGADO</span></c:when>
                                        <c:when test="${pedido.estado eq 'CANCELADO'}"><span class="estado cancelado">CANCELADO</span></c:when>
                                        <c:otherwise><span class="estado"><c:out value="${pedido.estado}"/></span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${pedido.estado eq 'RECIBIDO' or pedido.estado eq 'EN PREPARACIÓN'}">
                                            <form class="formulario-estado" action="${pageContext.request.contextPath}/admin/pedidos/estado" method="post">
                                                <input type="hidden" name="idPedido" value="${pedido.idPedido}">
                                                <c:if test="${not empty _csrf}">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                                </c:if>
                                                <select name="nuevoEstado" aria-label="Nuevo estado del pedido ${pedido.idPedido}" required>
                                                    <c:if test="${pedido.estado eq 'RECIBIDO'}"><option value="EN PREPARACIÓN">EN PREPARACIÓN</option></c:if>
                                                    <c:if test="${pedido.estado eq 'EN PREPARACIÓN'}"><option value="LISTO">LISTO</option></c:if>
                                                </select>
                                                <button type="submit">Actualizar</button>
                                            </form>
                                        </c:when>
                                        <c:when test="${pedido.estado eq 'ENTREGADO'}"><span class="finalizado">Pedido finalizado</span></c:when>
                                        <c:when test="${pedido.estado eq 'CANCELADO'}"><span class="texto-cancelado">Pedido cancelado</span></c:when>
                                        <c:when test="${pedido.estado eq 'LISTO'}"><span>Esperando asignación del cajero</span></c:when>
                                        <c:when test="${pedido.estado eq 'ASIGNADO'}"><span>Esperando recogida del repartidor</span></c:when>
                                        <c:when test="${pedido.estado eq 'EN CAMINO'}"><span>En proceso de entrega</span></c:when>
                                        <c:otherwise><span>Sin acciones disponibles</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </details>
            </c:if>
        </c:forEach>

        <c:if test="${not hayBloques}">
            <div class="tabla-contenedor vacio">Todavía no se han registrado pedidos.</div>
        </c:if>

    </section>
</main>
<footer class="pie">Sistema de gestión de pastelería</footer>
</body>
</html>
