using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.Authorization;
using pruebatecnica.Models;

var builder = WebApplication.CreateBuilder(args);

// 🔧 Servicios
builder.Services.AddSingleton<ConexionBD>();
builder.Services.AddHttpContextAccessor();
builder.Services.AddSession();
builder.Services.AddControllersWithViews(options =>
{
    var policy = new AuthorizationPolicyBuilder()
        .RequireAuthenticatedUser()
        .Build();
    options.Filters.Add(new AuthorizeFilter(policy));
});


// 🔐 Autenticación con cookies
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.LoginPath = "/Auth/Login";          // redirige si no hay sesión
        options.AccessDeniedPath = "/Auth/Login";   // redirige si no tiene permisos
        options.LogoutPath = "/Auth/Logout";
        options.ExpireTimeSpan = TimeSpan.FromHours(8);
        options.SlidingExpiration = true;
    });

// 🔏 Autorización con políticas personalizadas
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("Usuarios", policy =>
        policy.RequireClaim("permiso", "Usuarios"));
    options.AddPolicy("Permisos", policy =>
        policy.RequireClaim("permiso", "Permisos"));
    options.AddPolicy("Registro", policy =>
        policy.RequireClaim("permiso", "Registro"));
    options.AddPolicy("Impresiones", policy =>
        policy.RequireClaim("permiso", "Impresiones"));
});

var app = builder.Build();

// 🚀 Middleware
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();



// ⚠️ El orden correcto:
app.UseSession();          // primero: habilita sesión
app.UseRouting();
app.UseAuthentication();   // segundo: lee la cookie
app.UseAuthorization();    // tercero: valida permisos

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Auth}/{action=Login}/{id?}");

app.Run();

