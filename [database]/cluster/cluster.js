const mongodb = require("mongodb");
const utils = require("./utils");

const url = "mongodb://localhost:27017";

const db1 = 'Game';
const db2 = 'MDT';
const db3 = 'Permissions';
const db4 = 'Players';
const db5 = 'Storage';

let database1;
let database2;
let database3;
let database4;
let database5;

let MongoDB = {}

mongodb.MongoClient.connect(url, { useNewUrlParser: true, useUnifiedTopology: true }, function (err, client) {

    if (err) return console.log("[MongoDB][ERROR] Failed to connect: " + err.message);
    
    database1 = client.db(db1);
    database2 = client.db(db2);
    database3 = client.db(db3);
    database4 = client.db(db4);
    database5 = client.db(db5);

    console.log(`[MongoDB] Connected to database "${db1+" "+db2+" "+db3+" "+db4+" "+db5}".`);

    emit("onDatabaseConnect", db1,db2,db3,db4,db5);

});

function checkDatabaseReady(dbname) {

    if (dbname == 'Game') {

        if (!database1) {

            console.log(`[MongoDB][ERROR] Game Database is not connected.`);

            return false;

        }

        return true;

    } else if (dbname == 'MDT') {

        if (!database2) {

            console.log(`[MongoDB][ERROR] MDT Database is not connected.`);

            return false;

        }

        return true;

    } else if (dbname == 'Permissions') {

        if (!database3) {

            console.log(`[MongoDB][ERROR] Permissions Database is not connected.`);

            return false;

        }

        return true;

    } else if (dbname == 'Players') {

        if (!database4) {

            console.log(`[MongoDB][ERROR] Players Database is not connected.`);

            return false;

        }

        return true;

    } else if (dbname == 'Storage') {

        if (!database5) {

            console.log(`[MongoDB][ERROR] Storage Database is not connected.`);

            return false;
            
        }

        return true;

    } 

};

function checkParams(params) {

    return params !== null && typeof params === 'object';

};

function getParamsCollection(dbname, params) {

    if (!params.collection) return;

    if (dbname == 'Game') {

        return database1.collection(params.collection)

    } else if (dbname == 'MDT') {

        return database2.collection(params.collection)

    } else if (dbname == 'Permissions') {

        return database3.collection(params.collection)

    } else if (dbname == 'Players') {

        return database4.collection(params.collection)

    } else if (dbname == 'Storage') {

        return database5.collection(params.collection)

    }

};

const insertfun = function(dbname, params, callback) {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.insert: Invalid params object.`);

        let collection = getParamsCollection(dbname,params);

        if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

        if (checkParams(params)) {

            params.documents = [params.document];

            params.document = null;

        }

        let documents = params.documents;

        console.log(Array.isArray(documents))

        if (!documents || !Array.isArray(documents))

            return console.log(`[MongoDB][ERROR] exports.insert: Invalid 'params.documents' value. Expected object or array of objects.`);

        const options = utils.safeObjectArgument(params.options);

        collection.insertMany(documents, options, (err, result) => {

            if (err) {

                console.log(`[MongoDB][ERROR] exports.insert: Error "${err.message}".`);

                utils.safeCallback(callback, false, err.message);

                return;

            }

            let arrayOfIds = [];

            // Convert object to an array
            for (let key in result.insertedIds) {

                if (result.insertedIds.hasOwnProperty(key)) {

                    arrayOfIds[parseInt(key)] = result.insertedIds[key].toString();

                }

            }

            utils.safeCallback(callback, true, result.insertedCount, arrayOfIds);

        });

        process._tickCallback();

    } else {

        console.log('wrong database')
        
        return false;

    }

};

const insertfunawait = async (dbname, params) => {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {
        
        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.insert: Invalid params object.`);

        let collection = getParamsCollection(dbname,params);

        if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

        if (checkParams(params)) {

            params.documents = [params.document];

            params.document = null;

        }

        let documents = params.documents;

        console.log(Array.isArray(documents))

        if (!documents || !Array.isArray(documents))

            return console.log(`[MongoDB][ERROR] exports.insert: Invalid 'params.documents' value. Expected object or array of objects.`);

        const options = utils.safeObjectArgument(params.options);

        return await collection.insertMany(documents, options);

    } else {

        console.log('wrong database')

        return false;

    }

};

const findfun = function(dbname,params, callback) {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.find: Invalid params object.`);

        let collection = getParamsCollection(dbname,params);

        if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

        const query = utils.safeObjectArgument(params.query);

        const options = utils.safeObjectArgument(params.options);

        let cursor = collection.find(query, options);

        if (params.limit) cursor = cursor.limit(params.limit);

        cursor.toArray((err, documents) => {

            if (err) {

                console.log(`[MongoDB][ERROR] exports.find: Error "${err.message}".`);

                utils.safeCallback(callback, false, err.message);

                return;

            };

            utils.safeCallback(callback, true, utils.exportDocuments(documents));

        });

        process._tickCallback();

    } else {

        console.log('wrong database')

        return false;

    }
};

const findfunawait = async(dbname,params) =>{

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.find: Invalid params object.`);

        let collection = getParamsCollection(dbname,params);

        if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

        const query = utils.safeObjectArgument(params.query);

        const options = utils.safeObjectArgument(params.options);

        if (params.limit) {

            return validateDocuments (await collection.find(query, options).limit(params.limit).toArray()) 

        }

        return validateDocuments (await collection.find(query, options).toArray())

    } else {

        console.log('wrong database')

        return false;

    }

};

const updatefun = function(dbname, params, callback, isUpdateOne) {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.update: Invalid params object.`);

        let collection = getParamsCollection(dbname,params);

        if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

        query = utils.safeObjectArgument(params.query);

        update = utils.safeObjectArgument(params.update);

        options = utils.safeObjectArgument(params.options);

        const cb = (err, res) => {

            if (err) {

                console.log(`[MongoDB][ERROR] exports.update: Error "${err.message}".`);

                utils.safeCallback(callback, false, err.message);

                return;

            }

            utils.safeCallback(callback, true, res.result.nModified);

        };

        isUpdateOne ? collection.updateOne(query, update, options, cb) : collection.updateMany(query, update, options, cb);

        process._tickCallback();

    } else {

        console.log('wrong database')

        return false;

    }

};

const updatefunawait = async (dbname, params, isUpdateOne)=> {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.update: Invalid params object.`);

        let collection = getParamsCollection(dbname,params);

        if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

        query = utils.safeObjectArgument(params.query);

        update = utils.safeObjectArgument(params.update);

        options = utils.safeObjectArgument(params.options);

        if (isUpdateOne) {

            return validateDocuments (await collection.updateOne(query, update, options))
            
        } else {

            return validateDocuments (await collection.updateMany(query, update, options))

        }

    } else {

        console.log('wrong database')

        return false;

    }

};

const countfun = function(dbname, params, callback) {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.count: Invalid params object.`);

        let collection = getParamsCollection(dbname, params);

        if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

        const query = utils.safeObjectArgument(params.query);

        const options = utils.safeObjectArgument(params.options);

        collection.countDocuments(query, options, (err, count) => {

            if (err) {

                console.log(`[MongoDB][ERROR] exports.count: Error "${err.message}".`);

                utils.safeCallback(callback, false, err.message);
                
                return;

            }

            utils.safeCallback(callback, true, count);

        });

        process._tickCallback();

    } else {

        console.log('wrong database')

        return false;

    }

};

const countfunawait = async(dbname, params)=>  {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.count: Invalid params object.`);

        let collection = getParamsCollection(dbname, params);

        if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

        const query = utils.safeObjectArgument(params.query);

        const options = utils.safeObjectArgument(params.options);

        return await collection.countDocuments(query, options);

    } else {

        console.log('wrong database')

        return false;

    }

};

const deletefun = function(dbname, params, callback, isDeleteOne) {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.delete: Invalid params object.`);

        let collection = getParamsCollection(dbname,params);

        if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

        const query = utils.safeObjectArgument(params.query);

        const options = utils.safeObjectArgument(params.options);

        const cb = (err, res) => {

            if (err) {

                console.log(`[MongoDB][ERROR] exports.delete: Error "${err.message}".`);

                utils.safeCallback(callback, false, err.message);

                return;

            }

            utils.safeCallback(callback, true, res.result.n);

        };

        isDeleteOne ? collection.deleteOne(query, options, cb) : collection.deleteMany(query, options, cb);

        process._tickCallback();

    } else {

        console.log('wrong database')

        return false;

    }

};

const deletefunawait = async(dbname, params, isDeleteOne) =>  {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.delete: Invalid params object.`);

        let collection = getParamsCollection(dbname,params);

        if (!collection) return console.log(`[MongoDB][ERROR] exports.insert: Invalid collection "${params.collection}"`);

        const query = utils.safeObjectArgument(params.query);

        const options = utils.safeObjectArgument(params.options);

        if (isDeleteOne) {

            return validateDocuments (await collection.deleteOne(query, options))

        } else {

            return validateDocuments (await collection.deleteMany(query, options))

        }

    } else {

        console.log('wrong database')

        return false;

    }

};

const findandupdatefun = async (dbname, params, callback, isUpdateOne) => {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.findupdate Invalid Params object.`);

        let collection = getParamsCollection(dbname, params)

        if (!collection) return console.log(`[MongoDB][ERROR] exports.findupdate: Invalid Collection ${params.collection}`)

        const query = utils.safeObjectArgument(params.query);

        const options = utils.safeObjectArgument(params.options);

        const update = utils.safeObjectArgument(params.update);

        let afterData = null

        if (isUpdateOne) {

            await validateDocuments(collection.find(query, options).limit(1).toArray()).then((a) => {

                a.forEach(e => {

                    afterData = e._id

                });

            });

        } else {

            await validateDocuments(collection.find(query, options).toArray()).then((a) => {

                a.forEach(e => {

                    afterData = e._id

                });
                
            });

        }

        const cb = (err, res) => {

            if (err) {

                console.log(`[MongoDB][ERROR] exports.update: Error "${err.message}".`);

                utils.safeCallback(callback, false, err.message);

                return;

            }

            utils.safeCallback(callback, true, res.result.nModified);

        }

        if (afterData) {

            if (isUpdateOne) {

                collection.updateOne({_id:afterData}, update, options, cb)

            } else {
                
                collection.updateMany(query, update, options, cb)

            }

        } else {
            
            console.log(`[MongoDB][ERROR] exports.update: Error "No Data Found".`);

        }

        process._tickCallback();
        

    } else {

        console.log('Wrong Database')

        return false;

    }

}

const findandupdatefunawait = async(dbname, params, isUpdateOne) => {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.findupdate Invalid Params object.`);

        let collection = getParamsCollection(dbname, params)

        if (!collection) return console.log(`[MongoDB][ERROR] exports.findupdate: Invalid Collection ${params.collection}`)

        const query = utils.safeObjectArgument(params.query);

        const options = utils.safeObjectArgument(params.options);

        const update = utils.safeObjectArgument(params.update);

        let afterData = null

        if (isUpdateOne) {

            await validateDocuments(collection.find(query, options).limit(1).toArray()).then((a) => {

                a.forEach(e => {

                    afterData = e._id

                });

            });

        } else {

            await validateDocuments(collection.find(query, options).toArray()).then((a) => {

                a.forEach(e => {

                    afterData = e._id

                });
                
            });

        }

        if (afterData) {

            if (isUpdateOne) {

                return validateDocuments (await collection.updateOne({_id:afterData}, update, options))
                
            } else {
    
                return validateDocuments (await collection.updateMany(query, update, options))
    
            }

        } else {
            
            console.log(`[MongoDB][ERROR] exports.update: Error "No Data Found".`);

        }
        
    } else {

        console.log('Wrong Database')

        return false;

    }
}

const findandinsert = async (dbname, params, callback) => {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.findupdate Invalid Params object.`);

        let collection = getParamsCollection(dbname, params)

        if (!collection) return console.log(`[MongoDB][ERROR] exports.findupdate: Invalid Collection ${params.collection}`)

        const query = utils.safeObjectArgument(params.query);

        const options = utils.safeObjectArgument(params.options);

        const update = utils.safeObjectArgument(params.update);

        let afterData = null

        await validateDocuments(collection.find(query, options).toArray()).then((a) => {

            a.forEach(e => {

                afterData = e._id

            });
            
        });

        if (checkParams(params)) {

            params.documents = [params.document];

            params.document = null;

        }

        let documents = params.documents;

        console.log(Array.isArray(documents))

        if (!documents || !Array.isArray(documents))

            return console.log(`[MongoDB][ERROR] exports.insert: Invalid 'params.documents' value. Expected object or array of objects.`);

        if (!afterData) {

            collection.insertMany(documents, options, (err, result) => {

                if (err) {
    
                    console.log(`[MongoDB][ERROR] exports.insert: Error "${err.message}".`);
    
                    utils.safeCallback(callback, false, err.message);
    
                    return;
    
                }
    
                let arrayOfIds = [];
    
                // Convert object to an array
                for (let key in result.insertedIds) {
    
                    if (result.insertedIds.hasOwnProperty(key)) {
    
                        arrayOfIds[parseInt(key)] = result.insertedIds[key].toString();
    
                    }
    
                }
    
                utils.safeCallback(callback, true, result.insertedCount, arrayOfIds);
    
            });

        } else {
            
            console.log(`[MongoDB][ERROR] exports.update: Error "DataFound".`);

        }

        process._tickCallback();
        

    } else {

        console.log('Wrong Database')

        return false;

    }

}

const findandinsertawait = async (dbname, params) => {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.findupdate Invalid Params object.`);

        let collection = getParamsCollection(dbname, params)

        if (!collection) return console.log(`[MongoDB][ERROR] exports.findupdate: Invalid Collection ${params.collection}`)

        const query = utils.safeObjectArgument(params.query);

        const options = utils.safeObjectArgument(params.options);

        const update = utils.safeObjectArgument(params.update);

        let afterData = null

        await validateDocuments(collection.find(query, options).toArray()).then((a) => {

            a.forEach(e => {

                afterData = e._id

            });
            
        });

        if (checkParams(params)) {

            params.documents = [params.document];

            params.document = null;

        }

        let documents = params.documents;

        console.log(Array.isArray(documents))

        if (!documents || !Array.isArray(documents))

            return console.log(`[MongoDB][ERROR] exports.insert: Invalid 'params.documents' value. Expected object or array of objects.`);

        if (!afterData) {

            return await collection.insertMany(documents, options);

        } else {
            
            console.log(`[MongoDB][ERROR] exports.update: Error "DataFound".`);

        }

    } else {

        console.log('Wrong Database')

        return false;

    }

}

const findinsertupdate = async(dbname, params, callback) => {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.findupdate Invalid Params object.`);

        let collection = getParamsCollection(dbname, params)

        if (!collection) return console.log(`[MongoDB][ERROR] exports.findupdate: Invalid Collection ${params.collection}`)

        const query = utils.safeObjectArgument(params.query);

        const options = utils.safeObjectArgument(params.options);

        const update = utils.safeObjectArgument(params.update);

        let afterData = null

        await validateDocuments(collection.find(query, options).toArray()).then((a) => {

            a.forEach(e => {

                afterData = e._id

            });
            
        });

        if (afterData) {

            const cb = (err, res) => {

                if (err) {
    
                    console.log(`[MongoDB][ERROR] exports.update: Error "${err.message}".`);
    
                    utils.safeCallback(callback, false, err.message);
    
                    return;
    
                }
    
                utils.safeCallback(callback, true, true, res.result.nModified);
    
            }

            collection.updateOne({_id:afterData}, update, options, cb)

        } else {
            
            if (checkParams(params)) {

                params.documents = [params.document];
    
                params.document = null;
    
            }
    
            let documents = params.documents;
    
            console.log(Array.isArray(documents))
    
            if (!documents || !Array.isArray(documents))
    
                return console.log(`[MongoDB][ERROR] exports.insert: Invalid 'params.documents' value. Expected object or array of objects.`);

            collection.insertMany(documents, options, (err, result) => {

                if (err) {
    
                    console.log(`[MongoDB][ERROR] exports.insert: Error "${err.message}".`);
    
                    utils.safeCallback(callback, false, err.message);
    
                    return;
    
                }
    
                let arrayOfIds = [];
    
                // Convert object to an array
                for (let key in result.insertedIds) {
    
                    if (result.insertedIds.hasOwnProperty(key)) {
    
                        arrayOfIds[parseInt(key)] = result.insertedIds[key].toString();
    
                    }
    
                }
    
                utils.safeCallback(callback, true, false, result.insertedCount, arrayOfIds);
    
            });
        }

        process._tickCallback();
        

    } else {

        console.log('Wrong Database')

        return false;

    }

}

const findinsertupdateawait = async(dbname, params) => {

    if (dbname == 'Game' || dbname == 'MDT' || dbname == 'Permissions' || dbname == 'Players' || dbname == 'Storage') {

        if (!checkDatabaseReady(dbname)) return;

        if (!checkParams(params)) return console.log(`[MongoDB][ERROR] exports.findupdate Invalid Params object.`);

        let collection = getParamsCollection(dbname, params)

        if (!collection) return console.log(`[MongoDB][ERROR] exports.findupdate: Invalid Collection ${params.collection}`)

        const query = utils.safeObjectArgument(params.query);

        const options = utils.safeObjectArgument(params.options);

        const update = utils.safeObjectArgument(params.update);

        let afterData = null

        await validateDocuments(collection.find(query, options).toArray()).then((a) => {

            a.forEach(e => {

                afterData = e._id

            });
            
        });

        if (afterData) {

            return validateDocuments (await collection.updateOne({_id:afterData}, update, options))

        } else {
            
            if (checkParams(params)) {

                params.documents = [params.document];
    
                params.document = null;
    
            }
    
            let documents = params.documents;
    
            console.log(Array.isArray(documents))
    
            if (!documents || !Array.isArray(documents))
    
                return console.log(`[MongoDB][ERROR] exports.insert: Invalid 'params.documents' value. Expected object or array of objects.`);

            return await  collection.insertMany(documents, options);
        }

    } else {

        console.log('Wrong Database')

        return false;

    }

}

const validateDocuments = (data) => {

    if (!Array.isArray(data)) return data;

    return data.map((d) => {

        if (d._id && typeof d._id !== 'string') d._id = d._id.toString();

        return d;

    });

};

MongoDB.Async = {}

//always use insertmany function
MongoDB.Insert = insertfun                      // Required(dbname, parms:{collection,   document{data:"data"}})
MongoDB.Async.Insert = insertfunawait

//include find or limit
MongoDB.Find = findfun                          // Required(dbname, parms:{collection,   query{data:"data"}})   Optional(parms:{limit:1})
MongoDB.Async.Find = findfunawait

//include update single
MongoDB.Update = updatefun                      // Required(dbname, parms:{collection,   query{data:"data"},    update{data:"data"}})       Optional(isUpdateOne)
MongoDB.Async.Update = updatefunawait

//count values by givin values
MongoDB.Count = countfun                        // Required(dbname, parms:{collection,   query{data:"data"}})
MongoDB.Async.Count = countfunawait

//includes single delete
MongoDB.Delete = deletefun                      // Required(dbname, parms:{collection,   query{data:"data"}})   Optional(isDeleteOne)
MongoDB.Async.Delete = deletefunawait

//includes single find and update
MongoDB.FindAndUpdate = findandupdatefun        // Required(dbname, parms:{collection,   query{data:"data"},    update{data:"data"}})       Optional(isUpdateOne)
MongoDB.Async.FindAndUpdate = findandupdatefunawait

// finds data then insert if not found and always use insertmany function
MongoDB.FindAndInsert = findandinsert           // Required(dbname, parms:{collection,   query{data:"data"},    document{data:"data"}})
MongoDB.Async.FindAndInsert = findandinsertawait

//find data if found then update else insert
MongoDB.FindInsertUpdate = findinsertupdate     // Required(dbname, parms:{collection,   query{data:"data"},    document{data:"data"},  update{data:"data"}})
MongoDB.Async.FindInsertUpdate = findinsertupdateawait

exports('Load', () => MongoDB);