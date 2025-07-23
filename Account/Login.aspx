<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="sanderson.backend.Account.Login" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Sanderson-Satori-Raccons</title>
    <!-- Custom fonts for this template-->
    <link href="~/Content/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
        href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
        rel="stylesheet">
    <!-- Custom styles for this template-->
    <link href="~/Content/css/sb-admin-2.min.css" rel="stylesheet">
    <link href="~/Content/css/Custom.css" rel="stylesheet">
</head>
<body class="bg-gradient-primary">
    <div class="container">
        <!-- Outer Row -->
        <div class="row justify-content-center">
            <div class="col-xl-10 col-lg-12 col-md-9">
                <div class="card o-hidden border-0 shadow-lg my-5">
                    <div class="card-body p-0">
                        <!-- Nested Row within Card Body -->
                        <div class="row">
                            <div class="col-lg-6 d-none d-lg-block bg-login-image align-content-center">
                             <img src='<%= ResolveUrl("~/content/img/sanderson/LogoCompleto.jpeg") %>' alt="Logo"  style="margin:40px; width:80%; "  >
                            </div>
                            <div class="col-lg-6">
                                <div class="p-5">

                                    <div class="text-center">
                                        <h1 class="h4 text-gray-900 mb-4">Ingresar</h1>
                                    </div>
                                    <form class="user" runat="server">
                                        <div class="form-group">
                                            <asp:Label runat="server" AssociatedControlID="txtUsuario">Usuario</asp:Label>
                                            <asp:TextBox runat="server" ID="txtUsuario" Text="admin" CssClass="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <asp:Label runat="server" AssociatedControlID="txtPassword">Contraseña</asp:Label>
                                            <asp:TextBox runat="server" ID="txtPassword" Text="" CssClass="form-control" TextMode="Password" />

                                        </div>
                                    
                                        <asp:Button runat="server" ID="Button1" Text="Entrar" CssClass="btn btn-primary btn-block" OnClick="btnLogin_Click" />



                                        <asp:Label ID="lblError" runat="server" Visible="false"></asp:Label>

                                    </form>


                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    </div>

    <!-- Bootstrap core JavaScript-->
    <script src='<%=ResolveUrl("~/Content/vendor/jquery/jquery.min.js")%>'></script>
    <script src='<%=ResolveUrl("~/Content/vendor/bootstrap/js/bootstrap.bundle.min.js")%>'></script>

    <!-- Core plugin JavaScript-->
    <script src='<%=ResolveUrl("~/Content/vendor/jquery-easing/jquery.easing.min.js")%>'></script>

    <!-- Custom scripts for all pages-->
    <script src='<%=ResolveUrl("~/Content/js/sb-admin-2.min.js") %>'></script>

</body>

</html>










