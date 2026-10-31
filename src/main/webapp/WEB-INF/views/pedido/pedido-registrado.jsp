
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Pedido confirmado - Mi Pastelería</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="pagina-exito">

<header class="cabecera">
    <div class="logo">
        <h1>Mi Pastelería</h1>
        <p>Endulzamos tus mejores momentos</p>
    </div>

    <nav class="menu" aria-label="Navegación principal">
        <a href="${pageContext.request.contextPath}/catalogo">Inicio</a>
        <a href="${pageContext.request.contextPath}/carrito">Mi carrito</a>
        <a href="${pageContext.request.contextPath}/pedido/historial">Mis pedidos</a>
    </nav>
</header>

<main class="contenedor exito-contenedor">

    <div class="icono">✅</div>

    <h2>¡Pedido registrado correctamente!</h2>

    <p class="mensaje">
        Gracias por tu compra,
        <strong>
            <c:out value="${sessionScope.nombreUsuario}"/>
        </strong>.
        Hemos registrado tu pedido en nuestro sistema.
    </p>

    <div class="detalle">

        <p>
            <strong>Número de pedido:</strong>
            #<c:out value="${pedido.idPedido}"/>
        </p>

        <p>
            <strong>Fecha:</strong>
            <c:out value="${pedido.fechaPedido}"/>
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
            <span class="estado">
                <c:out value="${pedido.estado}"/>
            </span>
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

        <div class="total">
            Total: S/ <c:out value="${pedido.total}"/>
        </div>

    </div>

    <section class="seguimiento">

        <h3>📦 Sigue el estado de tu pedido</h3>

        <p class="seguimiento-descripcion">
            Consulta el avance de tu pedido desde que es recibido,
            pasa a preparación, queda listo, se asigna a un repartidor,
            sale en camino y finalmente se entrega.
        </p>

        <c:choose>
            <c:when test="${not empty pedido.codigoSeguimiento}">

                <div class="codigo" id="codigoSeguimiento">
                    <c:out value="${pedido.codigoSeguimiento}"/>
                </div>

                <button type="button"
                        class="boton-copiar"
                        id="botonCopiar">
                    📋 Copiar código
                </button>

                <div class="aviso-copia"
                     id="avisoCopia"
                     role="status"
                     aria-live="polite"></div>

                <c:url var="urlSeguimiento" value="/pedido/seguimiento">
                    <c:param name="codigo" value="${pedido.codigoSeguimiento}"/>
                </c:url>

                <div>
                    <a class="boton-seguimiento"
                       href="<c:out value='${urlSeguimiento}'/>">
                        🔎 Ver estado de mi pedido
                    </a>
                </div>

                <p class="seguimiento-descripcion">
                    Guarda este código para consultar tu pedido cuando lo necesites.
                </p>

            </c:when>

            <c:otherwise>
                <p class="aviso-codigo">
                    Este pedido todavía no tiene un código de seguimiento asignado.
                </p>

                <a class="boton-seguimiento"
                   href="${pageContext.request.contextPath}/pedido/historial">
                    Ver mis pedidos
                </a>
            </c:otherwise>
        </c:choose>

    </section>

    <a class="boton"
       href="${pageContext.request.contextPath}/catalogo">
        Seguir comprando
    </a>

    <a class="boton-secundario"
       href="${pageContext.request.contextPath}/pedido/historial">
        Ver mis pedidos
    </a>

</main>

<footer class="pie">
    Mi Pastelería - Productos hechos con cariño
</footer>

<script>
    const botonCopiar = document.getElementById('botonCopiar');

    if (botonCopiar) {
        botonCopiar.addEventListener('click', async function () {
            const elemento = document.getElementById('codigoSeguimiento');
            const aviso = document.getElementById('avisoCopia');

            if (!elemento || !aviso) {
                return;
            }

            const codigo = elemento.textContent.trim();

            try {
                if (!navigator.clipboard || !navigator.clipboard.writeText) {
                    throw new Error('Portapapeles no disponible');
                }

                await navigator.clipboard.writeText(codigo);

                aviso.textContent = 'Código copiado correctamente.';
            } catch (error) {
                aviso.textContent =
                    'No se pudo copiar automáticamente. Selecciona el código y cópialo manualmente.';
            }
        });
    }
</script>

</body>
</html>
