use iron::{AfterMiddleware,  IronResult, Request, Response};

pub struct CSPHeaderMiddleware;

  impl AfterMiddleware for CSPHeaderMiddleware {
     fn after(&self, _req: &mut Request, mut res: Response) -> IronResult<Response> {
        res.headers.append_raw("Allow-CSP-From", "*".into());

        Ok(res)
    }
}
