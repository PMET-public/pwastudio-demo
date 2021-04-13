import { ExpirationPlugin } from 'workbox-expiration';
import {
    registerRoute,
    setDefaultHandler,
    setCatchHandler
} from 'workbox-routing';
import { matchPrecache } from 'workbox-precaching';
import {
    CacheFirst,
    NetworkOnly,
    StaleWhileRevalidate
} from 'workbox-strategies';
import {
    isResizedImage,
    findSameOrLargerImage,
    createImageCacheHandler
} from './Utilities/imageCacheHandler';
import { isHTMLRoute } from './Utilities/routeHandler';
import {
    THIRTY_DAYS,
    MAX_NUM_OF_IMAGES_TO_CACHE,
    IMAGES_CACHE_NAME,
    OFFLINE_PAGE
} from './defaults';

/**
 * registerRoutes function contains all the routes that need to
 * be registered with workbox for caching and proxying.
 *
 * @returns {void}
 */
export default function() {
    const imageCacheHandler = createImageCacheHandler();

    registerRoute(
        new RegExp('(robots.txt|favicon.ico|manifest.json)'),
        new StaleWhileRevalidate()
    );

    /**
     * Route that checks for resized images in cache.
     */
    registerRoute(isResizedImage, ({ url, request, event }) => {
        const sameOrLargerImagePromise = findSameOrLargerImage(url, request);
        event.waitUntil(sameOrLargerImagePromise);
        return sameOrLargerImagePromise.then(
            response => response || imageCacheHandler.handle({ request, event })
        );
    });

    /**
     * Route to handle all types of images. Stores them in cache with a
     * cache name "images". They auto expire after 30 days and only 60
     * can be stored at a time.
     *
     * There is another route that handles images without width and options on them.
     * This route handles images that wont have width options on them.
     */
    registerRoute(
        /\.(?:png|gif|jpg|jpeg|svg)$/,
        new CacheFirst({
            cacheName: IMAGES_CACHE_NAME,
            plugins: [
                new ExpirationPlugin({
                    maxEntries: MAX_NUM_OF_IMAGES_TO_CACHE, // 60 Images
                    maxAgeSeconds: THIRTY_DAYS // 30 Days
                })
            ]
        })
    );

    /**
     * Route for all JS files and bundles. This route uses CacheFirst
     * strategy because if the file contents change, the file name will
     * change. There is no point in using StaleWhileRevalidate for JS files.
     */
    registerRoute(new RegExp(/\.js$/), new CacheFirst());

    /**
     * Catch (offline)
     */
    setDefaultHandler(new NetworkOnly());

    setCatchHandler(args => {
        const { url, request } = args;

        if (
            url.host === self.location.host &&
            request.method === 'GET' &&
            request.destination === 'document'
        ) {
            return matchPrecache(OFFLINE_PAGE);
        }

        return Response.error();
    });
}
