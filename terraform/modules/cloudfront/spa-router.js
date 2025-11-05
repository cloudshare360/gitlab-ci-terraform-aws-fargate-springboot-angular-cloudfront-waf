// Lambda@Edge function for Angular SPA routing
exports.handler = (event, context, callback) => {
    const request = event.Records[0].cf.request;
    const uri = request.uri;
    
    // Check if the URI is for an API call
    if (uri.startsWith('/api/')) {
        // Let API calls pass through
        callback(null, request);
        return;
    }
    
    // Check if the URI has a file extension
    if (uri.includes('.')) {
        // Static file request, let it pass through
        callback(null, request);
        return;
    }
    
    // For Angular routing, serve index.html for all other routes
    if (uri !== '/index.html' && !uri.includes('.')) {
        request.uri = '/index.html';
    }
    
    callback(null, request);
};