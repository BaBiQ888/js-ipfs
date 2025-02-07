import * as dagCBOR from '@ipld/dag-cbor'
import * as dagPB from '@ipld/dag-pb'
import concat from 'it-concat'
import { CID } from 'multiformats/cid'
import parseDuration from 'parse-duration'

/**
 * @type {Record<string, (buf: Buffer) => any>}
 */
const inputDecoders = {
  json: (buf) => JSON.parse(buf.toString()),
  cbor: (buf) => dagCBOR.decode(buf),
  protobuf: (buf) => dagPB.decode(buf),
  raw: (buf) => buf
}

/**
 * @type {Record<string, 'dag-cbor' | 'dag-pb' | 'raw'>}
 */
const formats = {
  cbor: 'dag-cbor',
  raw: 'raw',
  protobuf: 'dag-pb',
  'dag-cbor': 'dag-cbor',
  'dag-pb': 'dag-pb'
}

export default {
  command: 'put [data]',

  describe: 'accepts input from a file or stdin and parses it into an object of the specified format',

  builder: {
    data: {
      type: 'string'
    },
    format: {
      type: 'string',
      alias: 'f',
      default: 'cbor',
      describe: 'Format that the object will be added as',
      choices: ['dag-cbor', 'dag-pb', 'raw', 'cbor', 'protobuf']
    },
    'input-encoding': {
      type: 'string',
      alias: 'input-enc',
      default: 'json',
      describe: 'Format that the input object will be',
      choices: ['json', 'cbor', 'raw', 'protobuf']
    },
    pin: {
      type: 'boolean',
      default: true,
      describe: 'Pin this object when adding'
    },
    'hash-alg': {
      type: 'string',
      alias: 'hash',
      default: 'sha2-256',
      describe: 'Hash function to use'
    },
    'cid-version': {
      type: 'integer',
      describe: 'CID version. Defaults to 0 unless an option that depends on CIDv1 is passed',
      default: 0
    },
    'cid-base': {
      describe: 'Number base to display CIDs in.',
      type: 'string',
      default: 'base58btc'
    },
    preload: {
      type: 'boolean',
      default: true,
      describe: 'Preload this object when adding'
    },
    'only-hash': {
      type: 'boolean',
      default: false,
      describe: 'Only hash the content, do not write to the underlying block store'
    },
    timeout: {
      type: 'string',
      coerce: parseDuration
    }
  },

  /**
   * @param {object} argv
   * @param {import('../../types').Context} argv.ctx
   * @param {string} argv.data
   * @param {'dag-cbor' | 'dag-pb' | 'raw' | 'cbor' | 'protobuf'} argv.format
   * @param {'json' | 'cbor' | 'raw' | 'protobuf'} argv.inputEncoding
   * @param {import('multiformats/cid').CIDVersion} argv.cidVersion
   * @param {boolean} argv.pin
   * @param {string} argv.hashAlg
   * @param {string} argv.cidBase
   * @param {boolean} argv.preload
   * @param {boolean} argv.onlyHash
   * @param {number} argv.timeout
   */
  async handler ({ ctx: { ipfs, print, getStdin }, data, format, inputEncoding, pin, hashAlg, cidVersion, cidBase, preload, onlyHash, timeout }) {
    if (inputEncoding === 'cbor') {
      format = 'dag-cbor'
    } else if (inputEncoding === 'protobuf') {
      format = 'dag-pb'
    }

    format = formats[format]

    if (format !== 'dag-pb') {
      cidVersion = 1
    }

    /** @type {Buffer} */
    let source

    if (!data) {
      // pipe from stdin
      source = (await concat(getStdin(), { type: 'buffer' })).slice()
    } else {
      source = Buffer.from(data)
    }

    source = inputDecoders[inputEncoding](source)

    // Support legacy { "/" : "<CID>" } format so dag put is actually useful
    // on the command line: https://github.com/ipld/js-ipld-dag-cbor/issues/84
    if (inputEncoding === 'json' && format === 'dag-cbor') {
      source = objectSlashToCID(source)
    }

    const cid = await ipfs.dag.put(source, {
      format,
      hashAlg,
      version: cidVersion,
      onlyHash,
      preload,
      pin,
      timeout
    })
    const base = await ipfs.bases.getBase(cidBase)

    print(cid.toString(base.encoder))
  }
}

/**
 * @param {any} obj
 * @returns {any}
 */
function objectSlashToCID (obj) {
  if (Array.isArray(obj)) {
    return obj.map(objectSlashToCID)
  }

  if (obj && typeof obj === 'object') {
    const keys = Object.keys(obj)
    if (keys.length === 1 && '/' in obj) {
      if (typeof obj['/'] !== 'string') {
        throw new Error('link should have been a string')
      }
      return CID.parse(obj['/']) // throws if not a CID - consistent with go-ipfs
    }

    return keys.reduce((obj, key) => {
      obj[key] = objectSlashToCID(obj[key])
      return obj
    }, obj)
  }

  return obj
}
