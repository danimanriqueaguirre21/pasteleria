
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Mi carrito - Mi Pastelería</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="pagina-carrito">

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

        <a class="activo"
           aria-current="page"
           href="${pageContext.request.contextPath}/carrito">
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

<main class="contenido carrito-contenido">

    <div class="titulo-seccion">
        <h2>Mi carrito</h2>
        <p>Revisa los productos antes de finalizar tu compra.</p>
    </div>

    <c:if test="${not empty error}">
        <div class="error" role="alert">
            <c:out value="${error}"/>
        </div>
    </c:if>

    <c:choose>

        <c:when test="${empty carrito}">
            <div class="vacio">
                <h3>Tu carrito está vacío</h3>

                <p>
                    Explora nuestros productos y agrega tus favoritos.
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
                            <th>Imagen</th>
                            <th>Producto</th>
                            <th>Precio</th>
                            <th>Cantidad</th>
                            <th>Subtotal</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="item" items="${carrito}">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.producto.imagen}">
                                            <c:url var="rutaImagen"
                                                   value="/imagenes/${item.producto.imagen}"/>

                                            <img class="imagen-producto"
                                                 src="<c:out value='${rutaImagen}'/>"
                                                 alt="<c:out value='${item.producto.nombre}'/>"
                                                 loading="lazy">
                                        </c:when>

                                        <c:otherwise>
                                            <img class="imagen-producto"
                                                 src="${pageContext.request.contextPath}/imagenes/sin-imagen.jpg"
                                                 alt="Imagen no disponible"
                                                 loading="lazy">
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:out value="${item.producto.nombre}"/>
                                </td>

                                <td>
                                    S/ <c:out value="${item.producto.precio}"/>
                                </td>

                                <td>
                                    <form action="${pageContext.request.contextPath}/carrito/actualizar"
                                          method="post">

                                        <input type="hidden"
                                               name="idProducto"
                                               value="${item.producto.idProducto}">

                                        <c:if test="${not empty _csrf}">
                                            <input type="hidden"
                                                   name="${_csrf.parameterName}"
                                                   value="${_csrf.token}">
                                        </c:if>

                                        <input class="cantidad cantidad-auto"
                                               type="number"
                                               name="cantidad"
                                               value="${item.cantidad}"
                                               min="1"
                                               max="${item.producto.stock}"
                                               step="1"
                                               required
                                               aria-label="Cantidad de <c:out value='${item.producto.nombre}'/>">
                                    </form>
                                </td>

                                <td>
                                    S/ <c:out value="${item.subtotal}"/>
                                </td>

                                <td>
                                    <form action="${pageContext.request.contextPath}/carrito/eliminar"
                                          method="post">

                                        <input type="hidden"
                                               name="idProducto"
                                               value="${item.producto.idProducto}">

                                        <c:if test="${not empty _csrf}">
                                            <input type="hidden"
                                                   name="${_csrf.parameterName}"
                                                   value="${_csrf.token}">
                                        </c:if>

                                        <button class="boton boton-eliminar"
                                                type="submit">
                                            Eliminar
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            
            <div class="total">
                Total: S/ <c:out value="${total}"/>
            </div>

            
            <div class="acciones">
                <a class="boton"
                   href="${pageContext.request.contextPath}/catalogo">
                    Seguir comprando
                </a>

                <a class="boton-finalizar"
                   id="finalizarCompra"
                   href="${pageContext.request.contextPath}/pedido/confirmar">
                    Finalizar compra
                </a>
            </div>

        </c:otherwise>
    </c:choose>

</main>

<footer class="pie">
    Mi Pastelería · Productos hechos con cariño
</footer>

<script>
    document.querySelectorAll('.cantidad-auto').forEach(function (campo) {
        let temporizador;
        let enviando = false;

        const formulario = campo.closest('form');

        function guardarCantidad() {
            clearTimeout(temporizador);

            if (enviando || campo.value === campo.defaultValue) {
                return;
            }

            if (!campo.checkValidity()) {
                campo.reportValidity();
                return;
            }

            enviando = true;
            formulario.requestSubmit();
        }

        campo.addEventListener('input', function () {
            clearTimeout(temporizador);

            if (enviando || campo.value === '') {
                return;
            }

            if (!campo.checkValidity()) {
                return;
            }

            temporizador = setTimeout(guardarCantidad, 700);
        });

        campo.addEventListener('change', guardarCantidad);
    });

    const finalizar = document.getElementById('finalizarCompra');

    if (finalizar) {
        finalizar.addEventListener('click', function (evento) {
            const cantidades = document.querySelectorAll('.cantidad-auto');

            const pendiente = Array.from(cantidades).find(function (campo) {
                return campo.value !== campo.defaultValue;
            });

            if (pendiente) {
                evento.preventDefault();

                if (!pendiente.checkValidity()) {
                    pendiente.reportValidity();
                    return;
                }

                pendiente.closest('form').requestSubmit();
            }
        });
    }
</script>

</body>
</html>
