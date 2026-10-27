
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Contacto - Mi Pastelería</title>

    

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body class="pagina-contacto">

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

        <a class="activo"
           aria-current="page"
           href="${pageContext.request.contextPath}/contacto">
            Contacto
        </a>

        <a href="${pageContext.request.contextPath}/carrito">
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

        
        <c:if test="${not empty sessionScope.idUsuario and sessionScope.idRol eq 3}">
            <a href="${pageContext.request.contextPath}/cajero/panel">
                Panel del cajero
            </a>
        </c:if>

        
        <c:if test="${not empty sessionScope.idUsuario and sessionScope.idRol eq 4}">
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

<section class="presentacion-contacto">
    <span class="etiqueta-seccion">
        Estamos para ayudarte
    </span>

    <h2>Contáctanos</h2>

    <p>
        ¿Tienes alguna consulta sobre nuestros productos?
        Completa el formulario y envíanos tu mensaje.
    </p>
</section>

<main class="contenedor-contacto">

    
    <section class="seccion-formulario-contacto">

        <h3>Envíanos un mensaje</h3>

        <p>
            Completa los siguientes datos para
            comunicarte con Mi Pastelería.
        </p>

        
        <c:if test="${not empty exito}">
            <div class="mensaje-exito" role="status">
                <c:out value="${exito}"/>
            </div>
        </c:if>

        
        <c:if test="${not empty error}">
            <div class="mensaje-error" role="alert">
                <c:out value="${error}"/>
            </div>
        </c:if>

        <form class="formulario-contacto"
              action="${pageContext.request.contextPath}/contacto/enviar"
              method="post">

            
            <c:if test="${not empty _csrf}">
                <input type="hidden"
                       name="${_csrf.parameterName}"
                       value="${_csrf.token}">
            </c:if>

            <div class="grupo-formulario">
                <label for="nombre">Nombre completo</label>

                <input type="text"
                       id="nombre"
                       name="nombre"
                       placeholder="Ingresa tu nombre completo"
                       maxlength="100"
                       required>
            </div>

            <div class="grupo-formulario">
                <label for="correo">Correo electrónico</label>

                <input type="email"
                       id="correo"
                       name="correo"
                       placeholder="ejemplo@correo.com"
                       maxlength="150"
                       required>
            </div>

            <div class="grupo-formulario">
                <label for="asunto">Asunto</label>

                <select id="asunto" name="asunto" required>
                    <option value="">Selecciona un asunto</option>
                    <option value="Consulta de productos">Consulta de productos</option>
                    <option value="Consulta de pedidos">Consulta de pedidos</option>
                    <option value="Sugerencia">Sugerencia</option>
                    <option value="Reclamo">Reclamo</option>
                    <option value="Otro">Otro</option>
                </select>
            </div>

            <div class="grupo-formulario">
                <label for="mensaje">Mensaje</label>

                <textarea id="mensaje"
                          name="mensaje"
                          rows="6"
                          maxlength="2000"
                          placeholder="Escribe tu consulta o mensaje..."
                          required></textarea>
            </div>

            <button type="submit" class="boton-enviar-contacto">
                Enviar mensaje
            </button>

        </form>
    </section>

    
    <div class="informacion-contacto">

        <article class="tarjeta-contacto">
            <div class="icono-contacto" aria-hidden="true">📍</div>
            <h3>Ubicación</h3>
            <p>Huancayo, Junín, Perú</p>
        </article>

        <article class="tarjeta-contacto">
            <div class="icono-contacto" aria-hidden="true">📞</div>
            <h3>Teléfono</h3>
            <p>064 123456</p>
        </article>

        <article class="tarjeta-contacto">
            <div class="icono-contacto" aria-hidden="true">🕒</div>
            <h3>Horario de atención</h3>
            <p>Lunes a sábado<br>9:00 a 20:00</p>
        </article>

        <article class="tarjeta-contacto">
            <div class="icono-contacto" aria-hidden="true">✉️</div>
            <h3>Correo electrónico</h3>
            <p>contacto@pasteleria.com</p>
        </article>

    </div>

    <div class="accion-contacto">
        <a class="boton-contacto"
           href="${pageContext.request.contextPath}/catalogo">
            Ver nuestros productos
            <span aria-hidden="true">→</span>
        </a>
    </div>

</main>

<footer class="pie">
    Mi Pastelería · Productos hechos con cariño
</footer>

</body>
</html>
