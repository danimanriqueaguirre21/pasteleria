
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Seguimiento de pedido - Mi Pastelería</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="pagina-seguimiento">

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

            <a href="${pageContext.request.contextPath}/pedido/historial">
                Mis pedidos
            </a>

            <a class="activo"
               aria-current="page"
               href="${pageContext.request.contextPath}/pedido/seguimiento">
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
                    Hola, <c:out value="${sessionScope.nombreUsuario}"/>
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

<main class="contenedor seguimiento-contenedor">

    <h2>📦 Seguimiento de tu pedido</h2>

    <p class="descripcion">
        Introduce el código de seguimiento que recibiste al confirmar
        tu compra para conocer su estado actual.
    </p>

    
    <form class="formulario"
          method="get"
          action="${pageContext.request.contextPath}/pedido/seguimiento">

        <input type="text"
               name="codigo"
               maxlength="30"
               required
               placeholder="Ejemplo: PAS-2026-A7C91F2D8E304B56"
               value="<c:out value='${codigoBuscado}'/>"
               aria-label="Código de seguimiento">

        <button type="submit" class="boton">
            🔎 Buscar pedido
        </button>

    </form>

    
    <c:if test="${not empty error}">

        <div class="error" role="alert">
            <c:out value="${error}"/>
        </div>

    </c:if>

    
    <c:if test="${not empty pedido}">

        <div class="resultado">

            <h3>Información de tu pedido</h3>

            <p class="dato">
                <strong>Número de pedido:</strong>
                #<c:out value="${pedido.idPedido}"/>
            </p>

            <p class="dato">
                <strong>Código de seguimiento:</strong>

                <span class="codigo">
                    <c:out value="${pedido.codigoSeguimiento}"/>
                </span>
            </p>

            <p class="dato">
                <strong>Fecha de compra:</strong>
                <c:out value="${pedido.fechaPedido}"/>
            </p>

            <p class="dato">
                <strong>Estado actual:</strong>

                <span class="estado">
                    <c:out value="${pedido.estado}"/>
                </span>
            </p>

            <p class="dato">
                <strong>Total:</strong>
                S/ <c:out value="${pedido.total}"/>
            </p>

        </div>

        
        <c:choose>

            
            <c:when test="${pedido.estado eq 'CANCELADO'}">

                <div class="cancelado">

                    <strong>❌ Pedido cancelado</strong>

                    <p>
                        Este pedido fue cancelado y ya no continuará
                        con el proceso de preparación y entrega.
                    </p>

                </div>

            </c:when>

            
            <c:otherwise>

                <c:set var="etapaActual" value="0"/>

                
                <c:choose>

                    <c:when test="${pedido.estado eq 'RECIBIDO'}">
                        <c:set var="etapaActual" value="1"/>
                    </c:when>

                    <c:when test="${pedido.estado eq 'EN PREPARACIÓN'}">
                        <c:set var="etapaActual" value="2"/>
                    </c:when>

                    <c:when test="${pedido.estado eq 'LISTO'}">
                        <c:set var="etapaActual" value="3"/>
                    </c:when>

                    <c:when test="${pedido.estado eq 'ASIGNADO'}">
                        <c:set var="etapaActual" value="4"/>
                    </c:when>

                    <c:when test="${pedido.estado eq 'EN CAMINO'}">
                        <c:set var="etapaActual" value="5"/>
                    </c:when>

                    <c:when test="${pedido.estado eq 'ENTREGADO'}">
                        <c:set var="etapaActual" value="6"/>
                    </c:when>

                </c:choose>

                <c:choose>

                    <c:when test="${etapaActual gt 0}">

                        
                        <section class="progreso"
                                 aria-label="Progreso del pedido">

                            <h3>Progreso de tu pedido</h3>

                            
                            <div class="paso ${etapaActual gt 1 ? 'completado' : ''} ${etapaActual eq 1 ? 'actual' : ''}">

                                <div class="circulo">
                                    ${etapaActual gt 1 ? '✓' : '1'}
                                </div>

                                <div class="contenido-paso">
                                    <strong>Pedido recibido</strong>
                                    <p>
                                        Tu compra fue registrada correctamente.
                                    </p>
                                </div>

                            </div>

                            
                            <div class="paso ${etapaActual gt 2 ? 'completado' : ''} ${etapaActual eq 2 ? 'actual' : ''}">

                                <div class="circulo">
                                    ${etapaActual gt 2 ? '✓' : '2'}
                                </div>

                                <div class="contenido-paso">
                                    <strong>En preparación</strong>
                                    <p>
                                        Estamos preparando tus productos.
                                    </p>
                                </div>

                            </div>

                            
                            <div class="paso ${etapaActual gt 3 ? 'completado' : ''} ${etapaActual eq 3 ? 'actual' : ''}">

                                <div class="circulo">
                                    ${etapaActual gt 3 ? '✓' : '3'}
                                </div>

                                <div class="contenido-paso">
                                    <strong>Pedido listo</strong>
                                    <p>
                                        Tu pedido está preparado y listo
                                        para asignarse a un repartidor.
                                    </p>
                                </div>

                            </div>

                            
                            <div class="paso ${etapaActual gt 4 ? 'completado' : ''} ${etapaActual eq 4 ? 'actual' : ''}">

                                <div class="circulo">
                                    ${etapaActual gt 4 ? '✓' : '4'}
                                </div>

                                <div class="contenido-paso">
                                    <strong>Repartidor asignado</strong>
                                    <p>
                                        Se ha asignado un repartidor a tu pedido.
                                    </p>
                                </div>

                            </div>

                            
                            <div class="paso ${etapaActual gt 5 ? 'completado' : ''} ${etapaActual eq 5 ? 'actual' : ''}">

                                <div class="circulo">
                                    ${etapaActual gt 5 ? '✓' : '5'}
                                </div>

                                <div class="contenido-paso">
                                    <strong>En camino</strong>
                                    <p>
                                        El repartidor está llevando tu pedido
                                        a la dirección de entrega.
                                    </p>
                                </div>

                            </div>

                            
                            <div class="paso ${etapaActual gt 6 ? 'completado' : ''} ${etapaActual eq 6 ? 'actual' : ''}">

                                <div class="circulo">
                                    ${etapaActual eq 6 ? '✓' : '6'}
                                </div>

                                <div class="contenido-paso">
                                    <strong>Entregado</strong>
                                    <p>
                                        Tu pedido llegó a su destino.
                                    </p>
                                </div>

                            </div>

                        </section>

                    </c:when>

                    
                    <c:otherwise>

                        <div class="resultado">

                            <p>
                                Este pedido tiene un estado histórico:
                                <strong>
                                    <c:out value="${pedido.estado}"/>
                                </strong>.
                            </p>

                            <p>
                                Su estado se conserva tal como fue registrado.
                                No se muestra en el flujo de seis etapas.
                            </p>

                        </div>

                    </c:otherwise>

                </c:choose>

            </c:otherwise>

        </c:choose>

        
        <div class="acciones">

            <c:url var="urlActualizar"
                   value="/pedido/seguimiento">
                <c:param name="codigo"
                         value="${pedido.codigoSeguimiento}"/>
            </c:url>

            <a class="boton"
               href="<c:out value='${urlActualizar}'/>">
                🔄 Actualizar estado
            </a>

            <c:url var="urlDetalle"
                   value="/pedido/detalle">
                <c:param name="id"
                         value="${pedido.idPedido}"/>
            </c:url>

            <a class="enlace"
               href="<c:out value='${urlDetalle}'/>">
                Ver detalle del pedido
            </a>

        </div>

    </c:if>

    
    <div class="acciones">

        <a class="enlace"
           href="${pageContext.request.contextPath}/pedido/historial">
            ← Volver a mis pedidos
        </a>

    </div>

</main>

<footer class="pie">
    Mi Pastelería - Productos hechos con cariño
</footer>

</body>
</html>
