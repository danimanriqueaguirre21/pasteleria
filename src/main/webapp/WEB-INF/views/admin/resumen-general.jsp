
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Resumen - Mi Pastelería</title>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="estadisticas-page">

<c:set var="tituloAdmin" value="Resumen"/>
<c:set var="menuActivo" value="dashboard"/>
<%@ include file="menu.jsp" %>

<main class="contenedor estadisticas-contenido">

    

    <h2>Resumen general</h2>

    <p class="descripcion">
        Indicadores principales de los pedidos
        registrados en la pastelería.
    </p>

    <div class="resumen-grid">

        
        <div class="resumen-tarjeta">
            <h3>Importe total de pedidos</h3>

            <p class="resumen-valor">
                S/
                <fmt:formatNumber
                    value="${importeTotal}"
                    minFractionDigits="2"
                    maxFractionDigits="2"/>
            </p>
        </div>

        
        <div class="resumen-tarjeta">
            <h3>Total de pedidos</h3>

            <p class="resumen-valor">
                <c:out value="${totalPedidos}"/>
            </p>
        </div>

        
        <div class="resumen-tarjeta">
            <h3>Pedidos entregados</h3>

            <p class="resumen-valor">
                <c:out value="${totalEntregados}"/>
            </p>
        </div>

        
        <div class="resumen-tarjeta">
            <h3>Promedio por pedido</h3>

            <p class="resumen-valor">
                S/
                <fmt:formatNumber
                    value="${ticketPromedioGeneral}"
                    minFractionDigits="2"
                    maxFractionDigits="2"/>
            </p>
        </div>

        
        <div class="resumen-tarjeta">
            <h3>Unidades solicitadas</h3>

            <p class="resumen-valor">
                <c:out value="${totalUnidades}"/>
            </p>
        </div>

    </div>

    

    <h2>Gráficos estadísticos</h2>

    <p class="descripcion">
        Evolución diaria de los indicadores
        de la pastelería.
    </p>

    
    <section class="tarjeta">

        <h3>Ventas por día</h3>

        <p class="subtitulo">
            Importe total de pedidos registrados
            por fecha, expresado en soles.
        </p>

        <c:choose>
            <c:when test="${empty ventasDiarias}">
                <div class="sin-datos">
                    No existen pedidos registrados.
                </div>
            </c:when>

            <c:otherwise>
                <div class="grafico-contenedor">
                    <canvas id="graficoVentas"></canvas>
                </div>
            </c:otherwise>
        </c:choose>

    </section>

    
    <section class="tarjeta">

        <h3>Pedidos por día</h3>

        <p class="subtitulo">
            Cantidad de pedidos registrados
            en cada fecha.
        </p>

        <c:choose>
            <c:when test="${empty pedidosPorDia}">
                <div class="sin-datos">
                    No existen pedidos registrados.
                </div>
            </c:when>

            <c:otherwise>
                <div class="grafico-contenedor">
                    <canvas id="graficoPedidos"></canvas>
                </div>
            </c:otherwise>
        </c:choose>

    </section>

    
    <section class="tarjeta">

        <h3>Entregas por día</h3>

        <p class="subtitulo">
            Pedidos entregados según la fecha
            real de entrega registrada.
        </p>

        <c:choose>
            <c:when test="${empty entregasPorDia}">
                <div class="sin-datos">
                    No existen entregas con fecha registrada.
                </div>
            </c:when>

            <c:otherwise>
                <div class="grafico-contenedor">
                    <canvas id="graficoEntregas"></canvas>
                </div>
            </c:otherwise>
        </c:choose>

    </section>

    
    <section class="tarjeta">

        <h3>Promedio por pedido en cada día</h3>

        <p class="subtitulo">
            Importe promedio de los pedidos
            registrados en cada fecha.
        </p>

        <c:choose>
            <c:when test="${empty ticketPromedioPorDia}">
                <div class="sin-datos">
                    No existen pedidos para calcular
                    el ticket promedio.
                </div>
            </c:when>

            <c:otherwise>
                <div class="grafico-contenedor">
                    <canvas id="graficoTicket"></canvas>
                </div>
            </c:otherwise>
        </c:choose>

    </section>

    
    <section class="tarjeta">

        <h3>Unidades vendidas por día</h3>

        <p class="subtitulo">
            Cantidad de unidades incluidas
            en los pedidos de cada fecha.
        </p>

        <c:choose>
            <c:when test="${empty unidadesVendidasPorDia}">
                <div class="sin-datos">
                    No existen detalles de pedidos
                    para generar este gráfico.
                </div>
            </c:when>

            <c:otherwise>
                <div class="grafico-contenedor">
                    <canvas id="graficoUnidades"></canvas>
                </div>
            </c:otherwise>
        </c:choose>

    </section>

</main>

<footer class="estadisticas-pie">
    Sistema de gestión de Mi Pastelería
</footer>

<script>
    function crearGrafico(
        idCanvas,
        tipo,
        fechas,
        valores,
        etiqueta,
        colorBorde,
        colorFondo,
        tituloY,
        esMoneda
    ) {
        const canvas = document.getElementById(idCanvas);

        if (!canvas || typeof Chart === "undefined") {
            return;
        }

        new Chart(canvas, {
            type: tipo,

            data: {
                labels: fechas,

                datasets: [{
                    label: etiqueta,
                    data: valores,
                    borderColor: colorBorde,
                    backgroundColor: colorFondo,
                    borderWidth: tipo === "line" ? 3 : 1,
                    borderRadius: tipo === "bar" ? 6 : 0,
                    tension: 0.3,
                    fill: tipo === "line",
                    pointRadius: 5,
                    pointBackgroundColor: colorBorde
                }]
            },

            options: {
                responsive: true,
                maintainAspectRatio: false,

                scales: {
                    y: {
                        beginAtZero: true,

                        ticks: esMoneda
                            ? {}
                            : {
                                stepSize: 1,
                                precision: 0
                            },

                        title: {
                            display: true,
                            text: tituloY
                        }
                    },

                    x: {
                        title: {
                            display: true,
                            text: "Fecha"
                        }
                    }
                },

                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                if (esMoneda) {
                                    return "S/ " +
                                        Number(context.raw).toFixed(2);
                                }

                                return etiqueta + ": " + context.raw;
                            }
                        }
                    }
                }
            }
        });
    }
</script>

<c:if test="${not empty ventasDiarias}">
<script>
    crearGrafico(
        "graficoVentas",
        "bar",
        [
            <c:forEach var="dato"
                       items="${ventasDiarias}"
                       varStatus="estado">
                "${dato.key}"<c:if test="${!estado.last}">,</c:if>
            </c:forEach>
        ],
        [
            <c:forEach var="dato"
                       items="${ventasDiarias}"
                       varStatus="estado">
                ${dato.value}<c:if test="${!estado.last}">,</c:if>
            </c:forEach>
        ],
        "Importe de pedidos",
        "#2E5496",
        "rgba(46,84,150,0.65)",
        "Importe (S/)",
        true
    );
</script>
</c:if>

<c:if test="${not empty pedidosPorDia}">
<script>
    crearGrafico(
        "graficoPedidos",
        "line",
        [
            <c:forEach var="dato"
                       items="${pedidosPorDia}"
                       varStatus="estado">
                "${dato.key}"<c:if test="${!estado.last}">,</c:if>
            </c:forEach>
        ],
        [
            <c:forEach var="dato"
                       items="${pedidosPorDia}"
                       varStatus="estado">
                ${dato.value}<c:if test="${!estado.last}">,</c:if>
            </c:forEach>
        ],
        "Pedidos registrados",
        "#1F3864",
        "rgba(31,56,100,0.14)",
        "Cantidad de pedidos",
        false
    );
</script>
</c:if>

<c:if test="${not empty entregasPorDia}">
<script>
    crearGrafico(
        "graficoEntregas",
        "bar",
        [
            <c:forEach var="dato"
                       items="${entregasPorDia}"
                       varStatus="estado">
                "${dato.key}"<c:if test="${!estado.last}">,</c:if>
            </c:forEach>
        ],
        [
            <c:forEach var="dato"
                       items="${entregasPorDia}"
                       varStatus="estado">
                ${dato.value}<c:if test="${!estado.last}">,</c:if>
            </c:forEach>
        ],
        "Pedidos entregados",
        "#548235",
        "rgba(84,130,53,0.65)",
        "Cantidad de entregas",
        false
    );
</script>
</c:if>

<c:if test="${not empty ticketPromedioPorDia}">
<script>
    crearGrafico(
        "graficoTicket",
        "line",
        [
            <c:forEach var="dato"
                       items="${ticketPromedioPorDia}"
                       varStatus="estado">
                "${dato.key}"<c:if test="${!estado.last}">,</c:if>
            </c:forEach>
        ],
        [
            <c:forEach var="dato"
                       items="${ticketPromedioPorDia}"
                       varStatus="estado">
                ${dato.value}<c:if test="${!estado.last}">,</c:if>
            </c:forEach>
        ],
        "Promedio por pedido",
        "#C55A11",
        "rgba(197,90,17,0.14)",
        "Promedio (S/)",
        true
    );
</script>
</c:if>

<c:if test="${not empty unidadesVendidasPorDia}">
<script>
    crearGrafico(
        "graficoUnidades",
        "bar",
        [
            <c:forEach var="dato"
                       items="${unidadesVendidasPorDia}"
                       varStatus="estado">
                "${dato.key}"<c:if test="${!estado.last}">,</c:if>
            </c:forEach>
        ],
        [
            <c:forEach var="dato"
                       items="${unidadesVendidasPorDia}"
                       varStatus="estado">
                ${dato.value}<c:if test="${!estado.last}">,</c:if>
            </c:forEach>
        ],
        "Unidades solicitadas",
        "#3676B7",
        "rgba(54,118,183,0.65)",
        "Cantidad de unidades",
        false
    );
</script>
</c:if>

</body>
</html>
