package tools.descartes.teastore.recommender;

import io.opentelemetry.instrumentation.annotations.WithSpan;
import tools.descartes.teastore.entities.OrderItem;
import tools.descartes.teastore.recommender.rest.RecommendEndpoint;

import java.util.List;

public class RecommenderFacade {

    @WithSpan
    public static List<Long> getRecommendations(List<OrderItem> items, Long userId) {
        return new RecommendEndpoint().recommend(items, userId);
    }
}
