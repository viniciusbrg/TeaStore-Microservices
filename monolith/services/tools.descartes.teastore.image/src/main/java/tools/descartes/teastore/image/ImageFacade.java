package tools.descartes.teastore.image;

import tools.descartes.teastore.entities.ImageSizePreset;
import tools.descartes.teastore.entities.Product;
import tools.descartes.teastore.image.rest.ImageProviderEndpoint;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ImageFacade {

    public static Map<Long, String> getProductPreviewImages(List<Product> products) {
        HashMap<Long, String> img = new HashMap<>();
        for (Product p : products) {
            img.put(p.getId(), ImageSizePreset.PREVIEW.getSize().toString());
        }

        return new ImageProviderEndpoint().getProductImagesImpl(img);
    }

    public static Map<Long, String> getProductImages(List<Product> products, ImageSizePreset preset) {
        HashMap<Long, String> img = new HashMap<>();
        for (Product p : products) {
            img.put(p.getId(), preset.getSize().toString());
        }

        return new ImageProviderEndpoint().getProductImagesImpl(img);
    }

    public static String getProductImage(Product product, ImageSizePreset preset) {
        return getProductImages(List.of(product), preset).getOrDefault(product.getId(), "");
    }

    public static HashMap<String, String> getWebImages(List<String> names, ImageSizePreset preset) {
        HashMap<String, String> img = new HashMap<>();
        for (String name : names) {
            img.put(name, preset.getSize().toString());
        }

        return new HashMap<>(new ImageProviderEndpoint().getUiImages(img));
    }

    public static String getWebImage(String imageName, ImageSizePreset preset) {
        return getWebImages(List.of(imageName), preset).getOrDefault(imageName, "");
    }

    public static String getWebImageIcon(String imageName) {
        return new ImageProviderEndpoint()
                .getUiImages(new HashMap<>(Map.of(imageName, ImageSizePreset.ICON.getSize().toString())))
                .getOrDefault(imageName, "");
    }
}
