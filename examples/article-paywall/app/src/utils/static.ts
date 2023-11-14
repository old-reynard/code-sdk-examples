import path from "path";
import { NextFunction, Request, Response } from 'express';

// Middleware to filter image requests
function imageFileFilter(req: Request, res: Response, next: NextFunction) {
    const ext = path.extname(req.path).toLowerCase();

    // List of allowed image extensions
    const allowedExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.webp'];

    if (allowedExtensions.includes(ext)) {
        next();
    } else {
        res.status(404).send('Not found');
    }
}

export {
    imageFileFilter
}