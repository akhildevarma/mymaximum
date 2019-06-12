'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

var _babelTypes = require('babel-plugin-transform-es2015-classes/node_modules/babel-types');

var t = _interopRequireWildcard(_babelTypes);

var _vanilla = require('babel-plugin-transform-es2015-classes/lib/vanilla');

var _vanilla2 = _interopRequireDefault(_vanilla);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj.default = obj; return newObj; } }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; } /**
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                * override 原插件的run方法，在只有一个constructor的情况下，修改命名函数表达式名称
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                * @autor calefy<clfsw0201@gmail.com>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                * @since 2016-03-08
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                */


var Transformer = function (_ClassTransformer) {
  _inherits(Transformer, _ClassTransformer);

  function Transformer(path, file) {
    _classCallCheck(this, Transformer);

    return _possibleConstructorReturn(this, Object.getPrototypeOf(Transformer).call(this, path, file));
  }

  _createClass(Transformer, [{
    key: 'run',
    value: function run() {
      var _this2 = this;

      var superName = this.superName;
      var file = this.file;
      var body = this.body;

      //

      var constructorBody = this.constructorBody = t.blockStatement([]);
      this.constructor = this.buildConstructor();

      //

      var closureParams = [];
      var closureArgs = [];

      //
      if (this.isDerived) {
        closureArgs.push(superName);

        superName = this.scope.generateUidIdentifierBasedOnNode(superName);
        closureParams.push(superName);

        this.superName = superName;
      }

      //
      this.buildBody();

      // make sure this class isn't directly called
      constructorBody.body.unshift(t.expressionStatement(t.callExpression(file.addHelper("classCallCheck"), [t.thisExpression(), this.classRef])));

      body = body.concat(this.staticPropBody.map(function (fn) {
        return fn(_this2.classRef);
      }));

      if (this.classId) {
        // named class with only a constructor
        // run方法中仅有这里做了修改
        if (body.length === 1) {
          body[0].id = this.scope.generateUidIdentifier(body[0].id.name);
          return t.toExpression(body[0]);
        }
      }

      //
      body.push(t.returnStatement(this.classRef));

      var container = t.functionExpression(null, closureParams, t.blockStatement(body));
      container.shadow = true;
      return t.callExpression(container, closureArgs);
    }
  }]);

  return Transformer;
}(_vanilla2.default);

module.exports = Transformer;