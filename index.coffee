express = require 'express'
multer = require 'multer'
multerS3 = require 'multer-s3'
aws = require 'aws-sdk'
aws.config.update({
  accessKeyId: '',
  secretAccessKey: ''
});

app = express()

app.use (req, res, next) ->
  res.setHeader "Access-Control-Allow-Methods", "POST, PUT, OPTIONS, DELETE, GET"
  res.header "Access-Control-Allow-Origin", "http://localhost"
  res.header "Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept"
  next()

diskStorage = multer.diskStorage {
  destination: (req, file, cb) -> cb null, './uploads/'
  filename: (req, file, cb) ->
    datetimestamp = Date.now()

    if file
      console.log file
      filename = datetimestamp + file.originalname
      cb null, filename
    else
      cb null, null
}

s3 = new aws.S3 { params: { Bucket: 'images.slookup' } }
s3Storage = multerS3({
  s3: s3
  bucket: 'images.slookup',
  metadata: (req, file, cb) -> cb(null, { fieldName: file.fieldname })
  key: (req, file, cb) -> cb(null, Date.now().toString())
})

upload = multer({ storage: s3Storage }).single('file')

app.post '/upload', (req, res) ->
  upload req, res, (err) ->
    return res.json { error_code:1, err_desc: err } if err
    return res.json { error_code:0, err_desc: null }

app.get '/index', (req, res) -> res.json { status: 'alive' }

app.listen '3000', () -> console.log 'Running on 3000...'