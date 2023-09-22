package tools.descartes.teastore.persistence;

import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.Response;
import tools.descartes.teastore.entities.*;
import tools.descartes.teastore.persistence.rest.*;
import tools.descartes.teastore.registryclient.Service;
import tools.descartes.teastore.registryclient.loadbalancers.LoadBalancerTimeoutException;
import tools.descartes.teastore.registryclient.util.NotFoundException;

import java.util.List;

public class PersistenceFacade {

    /**
     * Returns the entity with the specified id. Returns null if it does not exist.
     *
     * @param id
     *            Id of the entity to find.
     * @param service
     *            The service to load balance.
     * @param endpointURI
     *            The endpoint URI (e.g., "products").
     * @param entityClass
     *            The class of entities to send/receive.
     *            Type of entity to handle.
     * @throws NotFoundException
     *             If 404 was returned.
     * @throws LoadBalancerTimeoutException
     *             On receiving the 408 status code and on repeated load balancer
     *             socket timeouts.
     * @return The entity; null if it does not exist.
     */
    public static Product getProduct(Service service, String endpointURI, Class<Product> entityClass, long id)
            throws NotFoundException, LoadBalancerTimeoutException {
        ProductEndpoint pedp = new ProductEndpoint();

        return pedp.findEntityById(id);
    }

    public static Category getCategory(Service service, String endpointURI, Class<Category> entityClass, long id)
            throws NotFoundException, LoadBalancerTimeoutException {
        return new CategoryEndpoint().findEntityById(id);
    }

    public static User getUserById(long id)
            throws NotFoundException, LoadBalancerTimeoutException {
        return new UserEndpoint().findEntityById(id);
    }

    public static int getProductCountForCategory(Long categoryId) {
        var result = (String) new ProductEndpoint().countForCategory(categoryId).getEntity();

        return Integer.parseInt(result);
    }


    public static List<Product> getProductsWithFilters(long categoryID, int startPosition, int numberProducts) {
        return new ProductEndpoint().listAllForCategory(categoryID, startPosition, numberProducts);
    }

    public static List<Category> getAllCategories() {
        return new CategoryEndpoint().listAllEntities(-1, -1);
    }

    public static List<Order> getAllOrdersFromUser(Long userId) {
        return new OrderEndpoint().listAllForUser(userId, -1, -1);
    }

    public static List<Order> getAllOrders() {
        return new OrderEndpoint().listAllEntities(-1, -1);
    }

    public static List<OrderItem> getAllOrdemItems() {
        return new OrderItemEndpoint().listAllEntities(-1, -1);
    }

    public static long placeNewOrder(Order order) {
        return new OrderEndpoint().createEntity(order);
    }

    public static long placeNewOrderItem(OrderItem orderItem) {
        return new OrderItemEndpoint().createEntity(orderItem);
    }

    public static User getUserByName(String name) {
        return (User) new UserEndpoint().findById(name).getEntity();
    }

    public static Response generateDatabase(Integer categories,
                                            Integer products,
                                            Integer users,
                                            Integer orders) {
        return new DatabaseGenerationEndpoint().generateDataBase(categories, products, users, orders);
    }

    public static Response generateDatabase() { return generateDatabase(null, null, null, null); }
}
