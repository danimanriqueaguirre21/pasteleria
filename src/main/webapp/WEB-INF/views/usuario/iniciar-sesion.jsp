<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar sesión | Mi Pastelería</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>
<body class="pagina-login">
<main class="login-container">
    <div class="logo-login" aria-hidden="true">🎂</div>
    <h1>Bienvenido</h1>
    <p class="subtitulo">Inicia sesión en nuestra pastelería</p>

    <c:if test="${not empty error}">
        <div class="mensaje error" role="alert"><c:out value="${error}"/></div>
    </c:if>
    <c:if test="${not empty mensaje}">
        <div class="mensaje exito" role="status"><c:out value="${mensaje}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/usuario/login" method="post">
        <c:if test="${not empty _csrf}">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
        </c:if>

        <label for="correo">Correo electrónico</label>
        <input type="email" id="correo" name="correo"
               placeholder="ejemplo@correo.com" autocomplete="username" required>

        <label for="contrasena">Contraseña</label>
        <input type="password" id="contrasena" name="contrasena"
               placeholder="Ingresa tu contraseña" autocomplete="current-password" required>

        <button type="submit" class="btn-login">Iniciar sesión</button>
    </form>

    <p class="registro">¿No tienes una cuenta?
        <a href="${pageContext.request.contextPath}/usuario/registro">Regístrate aquí</a>
    </p>
    <div class="volver">
        <a href="${pageContext.request.contextPath}/catalogo">← Volver al catálogo</a>
    </div>
</main>
</body>
</html>
