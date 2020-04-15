import Mozaik from 'mozaik';
import config from '../config';
import github from 'mozaik-ext-github/client';

const mozaik = new Mozaik(config);

mozaik.bus.registerApi('github', github);

mozaik.startServer();
