#import "AeroRouter.h"

@interface AeroRouter()
@property (nonatomic, readonly, copy) NSString *APIKey;
@property (nonatomic, readonly, copy) NSURL *baseURL;
@end

@implementation AeroRouter

- (instancetype)initWithAPIKey:(NSString *)APIkey baseURL:(NSURL *)baseURL
{
    self = [super init];
    if (!self) { return nil; }

    _APIKey = APIkey;
    _baseURL = baseURL;

    return self;
}

- (NSURL *)urlForPath:(NSString *)path
{
    return [NSURL URLWithString:path relativeToURL:self.baseURL];
}

- (NSURLRequest *)headLastUpdateRequestForAccountID:(NSInteger)account
{
    NSURL *url = [self urlForPath:[NSString stringWithFormat:@"/accounts/%@", @(account)]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"HEAD";
    [request setValue:self.APIKey forHTTPHeaderField:@"Http-Authorization"];
    [request setValue:@"application/vnd.echo-v2+json" forHTTPHeaderField:@"Accept"];
    return request;
}

- (NSURLRequest *)getFullContentRequestForAccountID:(NSInteger)account
{
    NSURL *url = [self urlForPath:[NSString stringWithFormat:@"/accounts/%@", @(account)]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request setValue:self.APIKey forHTTPHeaderField:@"Http-Authorization"];
    [request setValue:@"application/vnd.echo-v2+json" forHTTPHeaderField:@"Accept"];
    return request;
}


@end
