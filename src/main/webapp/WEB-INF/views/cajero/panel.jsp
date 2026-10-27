<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Panel del Cajero - Mi Pastelería</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="pagina-cajero">

<header class="cabecera">
    <div class="logo">
        <h1>
            Mi Pastelería
            <span class="rol">Cajero</span>
        </h1>
        <p>Endulzamos tus mejores momentos</p>
    </div>

    <nav class="menu" aria-label="Menú principal">
        <a class="activo"
           aria-current="page"
           href="${pageContext.request.contextPath}/cajero/panel">
            Panel del cajero
        </a>

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

            <button type="submit">Cerrar sesión</button>
        </form>
    </nav>
</header>

<main class="contenido cajero-contenido">

    <section class="titulo-seccion">
        <h2>Panel del Cajero</h2>
        <p>
            Gestiona los pedidos de Mi Pastelería,
            supervisa su preparación y asigna repartidores.
        </p>
    </section>

    

    <c:if test="${not empty mensaje}">
        <div class="alerta alerta-exito" role="status">
            <c:out value="${mensaje}"/>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alerta alerta-error" role="alert">
            <c:out value="${error}"/>
        </div>
    </c:if>

    <section class="panel venta-tienda">
        <h2>Venta en tienda</h2>
        <p class="descripcion-panel">
            Agrega uno o varios productos. Si el cliente al final lleva menos,
            cambia la cantidad o pulsa Quitar. Solo se cobra lo que queda en Esta venta.
        </p>

        <div class="buscador">
            <input type="search"
                   id="buscar-producto"
                   placeholder="Buscar producto"
                   aria-label="Buscar producto">
        </div>

        <c:choose>
            <c:when test="${empty productos}">
                <p class="sin-pedidos">No hay productos con ese nombre.</p>
            </c:when>
            <c:otherwise>
                <form method="post"
                      action="${pageContext.request.contextPath}/cajero/venta">
                    <c:if test="${not empty _csrf}">
                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}">
                    </c:if>

                    <div class="tabla-contenedor">
                        <table id="tabla-productos">
                            <thead>
                            <tr>
                                <th>Producto</th>
                                <th>Precio</th>
                                <th>Stock</th>
                                <th></th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="producto" items="${productos}">
                                <tr data-id="${producto.idProducto}"
                                    data-nombre="<c:out value='${producto.nombre}'/>">
                                    <td><c:out value="${producto.nombre}"/></td>
                                    <td class="precio-pedido">
                                        S/ <c:out value="${producto.precio}"/>
                                    </td>
                                    <td><c:out value="${producto.stock}"/></td>
                                    <td>
                                        <button type="button"
                                                class="boton agregar"
                                                data-id="${producto.idProducto}"
                                                data-nombre="<c:out value='${producto.nombre}'/>"
                                                data-precio="${producto.precio}"
                                                data-stock="${producto.stock}"
                                                <c:if test="${producto.stock <= 0}">disabled</c:if>>
                                            Agregar
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <div class="venta-actual">
                        <h3>Esta venta</h3>
                        <p id="venta-vacia">Todavía no hay productos.</p>
                        <table id="tabla-venta" hidden>
                            <thead>
                            <tr>
                                <th>Producto</th>
                                <th>Precio</th>
                                <th>Cantidad</th>
                                <th>Subtotal</th>
                                <th></th>
                            </tr>
                            </thead>
                            <tbody id="lineas-venta"></tbody>
                        </table>
                        <p id="total-venta" class="total-venta"></p>
                    </div>

                    <div class="datos-venta">
                        <label for="telefono-venta">Teléfono</label>
                        <label for="medio-pago">Pago</label>

                        <input id="telefono-venta"
                               type="tel"
                               name="telefono"
                               pattern="9[0-9]{8}"
                               maxlength="9"
                               placeholder="987654321"
                               required>

                        <select id="medio-pago" name="medioPago" required>
                            <option value="EFECTIVO">Efectivo</option>
                            <option value="YAPE">Yape</option>
                            <option value="PLIN">Plin</option>
                            <option value="TARJETA">Tarjeta</option>
                        </select>

                        <button type="submit"
                                id="registrar-venta"
                                class="boton boton-enviar"
                                disabled>
                            Registrar venta
                        </button>
                    </div>
                </form>

                <script>
                    (function () {
                        const lineas = document.getElementById("lineas-venta");
                        const vacia = document.getElementById("venta-vacia");
                        const tablaVenta = document.getElementById("tabla-venta");
                        const totalVenta = document.getElementById("total-venta");
                        const registrar = document.getElementById("registrar-venta");
                        const buscar = document.getElementById("buscar-producto");
                        const filasProducto = document.querySelectorAll("#tabla-productos tbody tr");

                        function dinero(valor) {
                            return "S/ " + valor.toFixed(2);
                        }

                        function filaDe(id) {
                            return lineas.querySelector('tr[data-id="' + id + '"]');
                        }

                        function actualizar() {
                            let total = 0;
                            const filas = lineas.querySelectorAll("tr");

                            filas.forEach(function (fila) {
                                const precio = Number(fila.dataset.precio);
                                const input = fila.querySelector(".cantidad-venta");
                                const cantidad = Number(input.value);
                                const subtotal = precio * (cantidad > 0 ? cantidad : 0);

                                fila.querySelector(".subtotal").textContent = dinero(subtotal);
                                total = total + subtotal;
                            });

                            let listaValida = filas.length > 0;

                            filas.forEach(function (fila) {
                                const cantidad = Number(fila.querySelector(".cantidad-venta").value);

                                if (!Number.isInteger(cantidad) || cantidad < 1) {
                                    listaValida = false;
                                }
                            });

                            const hayProductos = filas.length > 0;
                            vacia.hidden = hayProductos;
                            tablaVenta.hidden = !hayProductos;
                            totalVenta.textContent = hayProductos ? "Total: " + dinero(total) : "";
                            registrar.disabled = !listaValida;

                            filasProducto.forEach(function (fila) {
                                const elegida = filaDe(fila.dataset.id) !== null;
                                fila.classList.toggle("producto-elegido", elegida);
                            });
                        }

                        function crearFila(boton) {
                            const fila = document.createElement("tr");
                            fila.dataset.id = boton.dataset.id;
                            fila.dataset.precio = boton.dataset.precio;

                            const celdaNombre = document.createElement("td");
                            celdaNombre.textContent = boton.dataset.nombre;

                            const celdaPrecio = document.createElement("td");
                            celdaPrecio.className = "precio-pedido";
                            celdaPrecio.textContent = dinero(Number(boton.dataset.precio));

                            const input = document.createElement("input");
                            input.className = "cantidad cantidad-venta";
                            input.type = "number";
                            input.name = "cantidad";
                            input.min = "1";
                            input.max = boton.dataset.stock;
                            input.value = "1";
                            input.required = true;

                            const celdaCantidad = document.createElement("td");
                            celdaCantidad.appendChild(input);

                            const celdaSubtotal = document.createElement("td");
                            celdaSubtotal.className = "subtotal precio-pedido";

                            const quitar = document.createElement("button");
                            quitar.type = "button";
                            quitar.className = "boton quitar";
                            quitar.textContent = "Quitar";

                            const oculto = document.createElement("input");
                            oculto.type = "hidden";
                            oculto.name = "idProducto";
                            oculto.value = boton.dataset.id;

                            const celdaQuitar = document.createElement("td");
                            celdaQuitar.appendChild(quitar);
                            celdaQuitar.appendChild(oculto);

                            fila.append(celdaNombre, celdaPrecio, celdaCantidad, celdaSubtotal, celdaQuitar);

                            input.addEventListener("input", function () {
                                const stock = Number(boton.dataset.stock);
                                const cantidad = Number(input.value);

                                if (input.value === "") {
                                    actualizar();
                                    return;
                                }

                                if (cantidad === 0) {
                                    fila.remove();
                                    actualizar();
                                    return;
                                }

                                if (!Number.isInteger(cantidad) || cantidad < 1) {
                                    input.value = "1";
                                } else if (cantidad > stock) {
                                    input.value = String(stock);
                                }

                                actualizar();
                            });

                            quitar.addEventListener("click", function () {
                                fila.remove();
                                actualizar();
                            });

                            return fila;
                        }

                        document.querySelectorAll(".agregar").forEach(function (boton) {
                            boton.addEventListener("click", function () {
                                const existente = filaDe(boton.dataset.id);

                                if (existente) {
                                    const input = existente.querySelector(".cantidad-venta");
                                    const stock = Number(boton.dataset.stock);
                                    const actual = Number(input.value);

                                    if (actual < stock) {
                                        input.value = String(actual + 1);
                                    }
                                } else {
                                    lineas.appendChild(crearFila(boton));
                                }

                                actualizar();
                            });
                        });

                        buscar.addEventListener("input", function () {
                            const texto = buscar.value.trim().toLowerCase();

                            filasProducto.forEach(function (fila) {
                                const nombre = (fila.dataset.nombre || "").toLowerCase();
                                fila.hidden = texto !== "" && nombre.indexOf(texto) === -1;
                            });
                        });
                    })();
                </script>
            </c:otherwise>
        </c:choose>
    </section>

    

    <section class="resumen" aria-label="Resumen de pedidos">

        <article class="tarjeta">
            <h3>Pedidos pendientes</h3>
            <div class="numero">
                <c:out value="${pendientes}"/>
            </div>
        </article>

        <article class="tarjeta">
            <h3>En preparación</h3>
            <div class="numero">
                <c:out value="${enPreparacion}"/>
            </div>
        </article>

        <article class="tarjeta">
            <h3>En camino</h3>
            <div class="numero">
                <c:out value="${enCamino}"/>
            </div>
        </article>

        <article class="tarjeta">
            <h3>Pedidos entregados</h3>
            <div class="numero">
                <c:out value="${entregados}"/>
            </div>
        </article>

    </section>

    

    <section class="panel">

        <h2>Gestión de pedidos</h2>

        <p class="descripcion-panel">
            Los pedidos están separados por estado.
            Abre un bloque para ver solo esos pedidos.
        </p>

        <c:set var="hayBloques" value="false"/>

        <c:forEach var="bloque" items="${bloques}">
            <c:if test="${not empty bloque.value}">
                <c:set var="hayBloques" value="true"/>

                <details class="bloque-pedido"
                         <c:if test="${bloque.key eq 'RECIBIDO'
                                    or bloque.key eq 'EN PREPARACIÓN'
                                    or bloque.key eq 'LISTO'}">open</c:if>>
                    <summary>
                        <c:choose>
                            <c:when test="${bloque.key eq 'RECIBIDO'}">Pendientes</c:when>
                            <c:when test="${bloque.key eq 'EN PREPARACIÓN'}">En preparación</c:when>
                            <c:when test="${bloque.key eq 'LISTO'}">Listos para asignar</c:when>
                            <c:when test="${bloque.key eq 'ASIGNADO'}">Asignados</c:when>
                            <c:when test="${bloque.key eq 'EN CAMINO'}">En camino</c:when>
                            <c:when test="${bloque.key eq 'ENTREGADO'}">Entregados</c:when>
                            <c:when test="${bloque.key eq 'CANCELADO'}">Cancelados</c:when>
                            <c:otherwise><c:out value="${bloque.key}"/></c:otherwise>
                        </c:choose>
                        <span class="cantidad-bloque">
                            (<c:out value="${fn:length(bloque.value)}"/>)
                        </span>
                    </summary>

                    <div class="tabla-contenedor">
                        <table>
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Cliente</th>
                                <th>Total</th>
                                <th>Medio de pago</th>
                                <th>Estado actual</th>
                                <th>Repartidor asignado</th>
                                <th>Acciones</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="pedido" items="${bloque.value}">
                    <tr>

                        <td>
                            #<c:out value="${pedido.idPedido}"/>
                        </td>

                        <td>
                            <c:out value="${nombresClientes[pedido.idUsuario]}"/>
                        </td>

                        <td class="precio-pedido">
                            S/ <c:out value="${pedido.total}"/>
                        </td>

                        <td>
                            <span class="medio-pago">
                                <c:out value="${pedido.medioPago}"/>
                            </span>
                        </td>

                        

                        <td>
                            <c:choose>

                                <c:when test="${pedido.estado eq 'RECIBIDO'}">
                                    <span class="estado pendiente">
                                        Pendiente
                                    </span>
                                </c:when>

                                <c:when test="${pedido.estado eq 'EN PREPARACIÓN'}">
                                    <span class="estado preparacion">
                                        En preparación
                                    </span>
                                </c:when>

                                <c:when test="${pedido.estado eq 'LISTO'}">
                                    <span class="estado listo">
                                        Listo
                                    </span>
                                </c:when>

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

                                <c:when test="${pedido.estado eq 'CANCELADO'}">
                                    <span class="estado cancelado">
                                        Cancelado
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
                            <c:choose>
                                <c:when test="${not empty pedido.idRepartidor}">
                                    Usuario #<c:out value="${pedido.idRepartidor}"/>
                                </c:when>

                                <c:otherwise>
                                    <span class="sin-acciones">
                                        Sin asignar
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        

                        <td>
                            <c:choose>

                                

                                <c:when test="${pedido.estado eq 'RECIBIDO'}">

                                    <form class="form-estado"
                                          action="${pageContext.request.contextPath}/cajero/actualizar-estado"
                                          method="post">

                                        <input type="hidden"
                                               name="idPedido"
                                               value="${pedido.idPedido}">

                                        <input type="hidden"
                                               name="nuevoEstado"
                                               value="EN PREPARACIÓN">

                                        <c:if test="${not empty _csrf}">
                                            <input type="hidden"
                                                   name="${_csrf.parameterName}"
                                                   value="${_csrf.token}">
                                        </c:if>

                                        <button type="submit" class="boton">
                                            Iniciar preparación
                                        </button>
                                    </form>

                                </c:when>

                                

                                <c:when test="${pedido.estado eq 'EN PREPARACIÓN'}">

                                    <form class="form-estado"
                                          action="${pageContext.request.contextPath}/cajero/actualizar-estado"
                                          method="post">

                                        <input type="hidden"
                                               name="idPedido"
                                               value="${pedido.idPedido}">

                                        <input type="hidden"
                                               name="nuevoEstado"
                                               value="LISTO">

                                        <c:if test="${not empty _csrf}">
                                            <input type="hidden"
                                                   name="${_csrf.parameterName}"
                                                   value="${_csrf.token}">
                                        </c:if>

                                        <button type="submit" class="boton">
                                            Marcar como listo
                                        </button>
                                    </form>

                                </c:when>

                                

                                <c:when test="${pedido.estado eq 'LISTO'}">

                                    <form class="form-estado form-asignacion"
                                          action="${pageContext.request.contextPath}/cajero/asignar-repartidor"
                                          method="post">

                                        <input type="hidden"
                                               name="idPedido"
                                               value="${pedido.idPedido}">

                                        <c:if test="${not empty _csrf}">
                                            <input type="hidden"
                                                   name="${_csrf.parameterName}"
                                                   value="${_csrf.token}">
                                        </c:if>

                                        <c:choose>

                                            <c:when test="${not empty repartidores}">

                                                <label for="repartidor-${pedido.idPedido}">
                                                    Seleccionar repartidor
                                                </label>

                                                <select id="repartidor-${pedido.idPedido}"
                                                        name="idRepartidor"
                                                        class="selector-repartidor"
                                                        required>

                                                    <option value="" selected disabled>
                                                        Seleccione un repartidor
                                                    </option>

                                                    <c:forEach var="repartidor"
                                                               items="${repartidores}">

                                                        <option value="${repartidor.idUsuario}">
                                                            <c:out value="${repartidor.nombres}"/>
                                                            <c:out value=" ${repartidor.apellidos}"/>
                                                        </option>

                                                    </c:forEach>

                                                </select>

                                                <button type="submit"
                                                        class="boton boton-enviar">
                                                    Asignar repartidor
                                                </button>

                                            </c:when>

                                            <c:otherwise>

                                                <span class="ayuda-repartidor">
                                                    No hay repartidores activos disponibles.
                                                </span>

                                                <button type="button"
                                                        class="boton boton-enviar"
                                                        disabled>
                                                    Asignar repartidor
                                                </button>

                                            </c:otherwise>

                                        </c:choose>

                                    </form>

                                </c:when>

                                

                                <c:otherwise>
                                    <span class="sin-acciones">
                                        Sin acciones disponibles
                                    </span>
                                </c:otherwise>

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
            <p class="sin-pedidos">Todavía no hay pedidos registrados.</p>
        </c:if>
    </section>

</main>

<footer class="pie">
    Mi Pastelería · Productos hechos con cariño
</footer>

</body>
</html>