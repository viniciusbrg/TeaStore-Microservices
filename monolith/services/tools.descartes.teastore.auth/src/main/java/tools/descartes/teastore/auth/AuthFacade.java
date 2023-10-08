package tools.descartes.teastore.auth;

import io.opentelemetry.instrumentation.annotations.WithSpan;
import tools.descartes.teastore.auth.rest.AuthCartRest;
import tools.descartes.teastore.auth.rest.AuthUserActionsRest;
import tools.descartes.teastore.entities.message.SessionBlob;

public class AuthFacade {

    @WithSpan
    public static boolean isLoggedIn(SessionBlob blob) {
        return new AuthUserActionsRest().isLoggedIn(blob).getEntity() != null;
    }
    @WithSpan
    public static SessionBlob addProductToCart(SessionBlob sessionBlob, long productID) {
        return (SessionBlob) new AuthCartRest().addProductToCart(sessionBlob, productID).getEntity();
    }

    @WithSpan
    public static SessionBlob removeProductFromCart(SessionBlob sessionBlob, long productID) {
        return (SessionBlob) new AuthCartRest().removeProductFromCart(sessionBlob, productID).getEntity();
    }
    @WithSpan
    public static SessionBlob updateQuantity(SessionBlob blob, long productId, int newQuantity) {
        return (SessionBlob) new AuthCartRest().updateQuantity(blob, productId, newQuantity).getEntity();

    }
    @WithSpan
    public static SessionBlob placeOrder(SessionBlob blob, String addressName, String address1,
                                         String address2, String creditCardCompany, String creditCardExpiryDate,
                                         long totalPriceInCents, String creditCardNumber) {
        return (SessionBlob) new AuthUserActionsRest().placeOrder(blob, totalPriceInCents, addressName, address1, address2, creditCardCompany, creditCardNumber, creditCardExpiryDate).getEntity();
    }

    @WithSpan
    public static SessionBlob login(SessionBlob sessionBlob, String username, String password) {
        return (SessionBlob) new AuthUserActionsRest().login(sessionBlob, username, password).getEntity();
    }

    @WithSpan
    public static SessionBlob logout(SessionBlob sessionBlob) {
        return (SessionBlob) new AuthUserActionsRest().logout(sessionBlob).getEntity();
    }
}
