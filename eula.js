"use strict"

const {get} = require('https');
const {log, error} = console, {argv, exit, platform:os} = process;
const eula = 'https://shakti.com/license.php';

const bail = m => error(m)||exit(1);

const getall = (u,o={}) => new Promise(t => get(u,o,x => {let data = '';
    x.on('data', x => data += x).on('end', _=>t(data))})
     .on('error', _=>bail("!net")));

const parse_eula = x => x.split('<body>', 2)[1]
    .replace(/<[/]?(\w+).*?>|[\t\n]+/g, (x,y)=>y==='p'?'\n':y?'':'').trim();

Promise.all([
     ()=>eula,
     getall(eula).then(parse_eula).catch(_=>bail("!eula"))
    ])
    .then(x=>log(`${x[0]}\n${x[1].replace(/\n/g, '\\n')}`))
    .catch(_=>bail("!fatal"))

//:~
