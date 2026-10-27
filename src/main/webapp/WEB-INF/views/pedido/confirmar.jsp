
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Confirmar pedido - Mi Pastelería</title>

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

        <a href="${pageContext.request.contextPath}/catalogo">
            Catálogo
        </a>

        <a href="${pageContext.request.contextPath}/publicidad">
            Promociones
        </a>

        <a href="${pageContext.request.contextPath}/contacto">
            Contacto
        </a>

        <c:if test="${empty sessionScope.idUsuario
                      or sessionScope.idRol eq 2}">
            <a href="${pageContext.request.contextPath}/carrito">
                Carrito
            </a>
        </c:if>

        <c:if test="${not empty sessionScope.idUsuario
                      and sessionScope.idRol eq 2}">
            <a href="${pageContext.request.contextPath}/pedido/historial">
                Mis pedidos
            </a>

            <a href="${pageContext.request.contextPath}/pedido/seguimiento">
                Seguimiento
            </a>
        </c:if>

        <c:if test="${esAdministrador}">
            <details class="menu-administracion">
                <summary>
                    ⚙ Administración <span aria-hidden="true">▾</span>
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

        <c:if test="${not empty sessionScope.idUsuario
                      and sessionScope.idRol eq 3}">
            <a href="${pageContext.request.contextPath}/cajero/panel">
                Panel del cajero
            </a>
        </c:if>

        <c:if test="${not empty sessionScope.idUsuario
                      and sessionScope.idRol eq 4}">
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

                    <button type="submit">Cerrar sesión</button>
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

<main class="contenido confirmar-contenedor">

    <h2>Confirmar pedido</h2>

    <p>
        Hola,
        <strong>
            <c:out value="${sessionScope.nombreUsuario}"/>
        </strong>.
        Revisa tu compra antes de confirmarla.
    </p>

    <c:if test="${not empty error}">
        <div class="error" role="alert">
            <c:out value="${error}"/>
        </div>
    </c:if>

    <h3>Resumen de compra</h3>

    <div class="tabla-contenedor">
        <table>
            <thead>
                <tr>
                    <th>Producto</th>
                    <th>Cantidad</th>
                    <th>Subtotal</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="item" items="${carrito}">
                    <tr>
                        <td>
                            <c:out value="${item.producto.nombre}"/>
                        </td>

                        <td>
                            <c:out value="${item.cantidad}"/>
                        </td>

                        <td>
                            S/ <c:out value="${item.subtotal}"/>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="total">
        Total: S/ <c:out value="${total}"/>
    </div>

    <c:choose>
        <c:when test="${empty carrito}">
            <div class="error">
                Tu carrito está vacío. Agrega productos antes de confirmar un pedido.
            </div>

            <a class="volver boton-secundario"
               href="${pageContext.request.contextPath}/catalogo">
                Ver productos
            </a>
        </c:when>

        <c:otherwise>

            <form id="formConfirmarPedido"
                  action="${pageContext.request.contextPath}/pedido/confirmar"
                  method="post">

                <c:if test="${not empty _csrf}">
                    <input type="hidden"
                           name="${_csrf.parameterName}"
                           value="${_csrf.token}">
                </c:if>

                <h3>Datos de entrega</h3>

                <label for="direccionEntrega">
                    Dirección de entrega
                </label>

                <input type="text"
                       id="direccionEntrega"
                       name="direccionEntrega"
                       placeholder="Ejemplo: Av. Ferrocarril 123, Huancayo"
                       value="<c:out value='${direccionEntrega}'/>"
                       maxlength="255"
                       required>

                <label for="telefono">
                    Número de celular
                </label>

                <input type="tel"
                       id="telefono"
                       name="telefono"
                       placeholder="Ejemplo: 987654321"
                       value="<c:out value='${telefono}'/>"
                       pattern="9[0-9]{8}"
                       maxlength="9"
                       inputmode="numeric"
                       title="Ingrese un celular peruano de 9 dígitos que comience con 9"
                       required>

                <h3>Selecciona tu medio de pago</h3>

                <div class="medios-pago">

                    <label class="opcion-pago">
                        <input type="radio"
                               name="medioPago"
                               value="YAPE"
                               <c:if test="${medioPago eq 'YAPE'}">checked="checked"</c:if>
                               required>

                        <span class="contenido-pago">
                            <span class="icono-pago">📱</span>
                            <span class="nombre-pago">Yape</span>
                            <span class="descripcion-pago">Billetera digital</span>
                        </span>
                    </label>

                    <label class="opcion-pago">
                        <input type="radio"
                               name="medioPago"
                               value="PLIN"
                               <c:if test="${medioPago eq 'PLIN'}">checked="checked"</c:if>
                               required>

                        <span class="contenido-pago">
                            <span class="icono-pago">📲</span>
                            <span class="nombre-pago">Plin</span>
                            <span class="descripcion-pago">Billetera digital</span>
                        </span>
                    </label>

                    <label class="opcion-pago">
                        <input type="radio"
                               name="medioPago"
                               value="TARJETA"
                               <c:if test="${medioPago eq 'TARJETA'}">checked="checked"</c:if>
                               required>

                        <span class="contenido-pago">
                            <span class="icono-pago">💳</span>
                            <span class="nombre-pago">Tarjeta</span>
                            <span class="descripcion-pago">Débito o crédito</span>
                        </span>
                    </label>

                </div>

                <div id="informacionPago"
                     class="informacion-pago"
                     role="status"
                     aria-live="polite">
                    Selecciona un medio de pago para continuar.
                </div>

                <button type="submit"
                        id="botonConfirmar"
                        class="boton boton-confirmar">
                    Confirmar pedido
                </button>

                <a class="volver boton-secundario"
                   href="${pageContext.request.contextPath}/carrito">
                    Volver al carrito
                </a>

            </form>

        </c:otherwise>
    </c:choose>

</main>

<footer class="pie">
    Mi Pastelería - Productos hechos con cariño
</footer>

<script>
    const opcionesPago =
        document.querySelectorAll('input[name="medioPago"]');

    const informacionPago =
        document.getElementById('informacionPago');

    function actualizarInformacionPago() {
        const seleccionado =
            document.querySelector('input[name="medioPago"]:checked');

        if (!informacionPago) {
            return;
        }

        if (!seleccionado) {
            informacionPago.textContent =
                'Selecciona un medio de pago para continuar.';
            return;
        }

        switch (seleccionado.value) {
            case 'YAPE':
                informacionPago.textContent =
                    'Seleccionaste Yape. El pedido registrará Yape como medio de pago. El pago deberá verificarse por separado.';
                break;

            case 'PLIN':
                informacionPago.textContent =
                    'Seleccionaste Plin. El pedido registrará Plin como medio de pago. El pago deberá verificarse por separado.';
                break;

            case 'TARJETA':
                informacionPago.textContent =
                    'Seleccionaste Tarjeta. Esta versión registra tu elección, pero todavía no procesa pagos con tarjeta.';
                break;

            default:
                informacionPago.textContent =
                    'Selecciona un medio de pago para continuar.';
        }
    }

    opcionesPago.forEach(function (opcion) {
        opcion.addEventListener('change', actualizarInformacionPago);
    });

    actualizarInformacionPago();

    const formulario =
        document.getElementById('formConfirmarPedido');

    const botonConfirmar =
        document.getElementById('botonConfirmar');

    if (formulario && botonConfirmar) {
        let enviando = false;

        formulario.addEventListener('submit', function (evento) {
            if (enviando) {
                evento.preventDefault();
                return;
            }

            enviando = true;
            botonConfirmar.disabled = true;
            botonConfirmar.textContent = 'Procesando pedido...';
        });
    }
</script>

</body>
</html>
