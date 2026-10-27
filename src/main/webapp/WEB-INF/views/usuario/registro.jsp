<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrarse | Mi Pastelería</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body class="pagina-registro">
<main class="registro-container">
    <div class="logo" aria-hidden="true">🧁</div>
    <h1>Crear cuenta</h1>
    <p class="subtitulo">Regístrate para comprar en nuestra pastelería</p>

    <c:if test="${not empty error}">
        <div class="error" role="alert"><c:out value="${error}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/usuario/registrar" method="post">
        <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
        </c:if>

        <label for="nombres">Nombres</label>
        <input type="text" id="nombres" name="nombres" placeholder="Ingresa tus nombres"
               maxlength="100" autocomplete="given-name" required>

        <label for="apellidos">Apellidos</label>
        <input type="text" id="apellidos" name="apellidos" placeholder="Ingresa tus apellidos"
               maxlength="100" autocomplete="family-name" required>

        <label for="correo">Correo electrónico</label>
        <input type="email" id="correo" name="correo" placeholder="ejemplo@correo.com"
               maxlength="150" autocomplete="email" required>

        <label for="contrasena">Contraseña</label>
        <input type="password" id="contrasena" name="contrasena" placeholder="Mínimo 8 caracteres"
               minlength="8" autocomplete="new-password" aria-describedby="nota-contrasena" required>
        <p class="nota" id="nota-contrasena">La contraseña debe tener al menos 8 caracteres.</p>

        <button type="submit" class="btn-registrar">Crear cuenta</button>
    </form>

    <div class="enlace">¿Ya tienes una cuenta?
        <a href="${pageContext.request.contextPath}/usuario/login">Inicia sesión</a>
    </div>
    <div class="enlace volver">
        <a href="${pageContext.request.contextPath}/catalogo">← Volver al catálogo</a>
    </div>
</main>
</body>
</html>
