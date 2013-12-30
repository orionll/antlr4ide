/*
 * generated by Xtext
 */
package com.github.jknack.scoping

import org.eclipse.xtext.scoping.IScope
import com.github.jknack.antlr4.Grammar
import org.eclipse.emf.ecore.EReference
import com.google.common.collect.Lists
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.emf.ecore.EObject
import com.github.jknack.antlr4.Imports
import com.github.jknack.antlr4.Rule
import com.github.jknack.antlr4.ParserRule
import com.github.jknack.antlr4.LexerRule
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import java.util.List
import com.github.jknack.antlr4.V3Tokens
import com.github.jknack.antlr4.V4Tokens
import com.github.jknack.antlr4.Options
import com.github.jknack.antlr4.TokenVocab
import org.eclipse.emf.ecore.util.EcoreUtil

/**
 * This class contains custom scoping description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation.html#scoping
 * on how and when to use it 
 *
 */
class Antlr4ScopeProvider extends AbstractDeclarativeScopeProvider {
  def IScope scope_ParserRule(Grammar grammar, EReference reference) {
  }

  override getScope(EObject context, EReference reference) {
    val candidate = rule(context)
    if (candidate instanceof Rule) {
      return scopeFor(candidate)
    }
    return super.getScope(context, reference);
  }

  def dispatch IScope scopeFor(ParserRule rule) {
    val grammar = rule.eContainer as Grammar;
    val scopes = Lists.<EObject>newArrayList()
    scopes.addAll(grammar.rules)
    // traverse prequels
    for (prequel : grammar.prequels) {
      try {
        scopeFor(prequel, scopes, Rule)
      } catch (IllegalArgumentException ex) {
        // not all the prequel define rules
      }
    }
    return Scopes.scopeFor(scopes, Antlr4NameProvider.nameFn, IScope.NULLSCOPE)
  }

  def dispatch void scopeFor(Imports imports, List<EObject> scopes, Class<? extends Rule> filter) {
    for(delegate : imports.imports) {
      scopes.addAll(delegate.importURI.rules.filter(filter))
    }
  }

  def dispatch void scopeFor(Options options, List<EObject> scopes, Class<? extends Rule> filter) {
    for(option : options.options) {
      if (option instanceof TokenVocab) {
        scopeFor(option, scopes)
      }
    }
  }

  def void scopeFor(TokenVocab tokenVocab, List<EObject> scopes) {
    val grammar = tokenVocab.importURI;
    if (grammar != null) {
      lexerRules(grammar, scopes);
      for (prequel : grammar.prequels) {
        try {
          scopeFor(prequel, scopes, Rule)
        } catch (IllegalArgumentException ex) {
          // not all the prequel define rules
        }
      }
    }
  }

  def dispatch void scopeFor(V3Tokens tokens, List<EObject> scopes, Class<? extends Rule> filter) {
    for(token : tokens.tokens) {
      scopes.addAll(token)
    }
  }

  def dispatch void scopeFor(V4Tokens tokens, List<EObject> scopes, Class<? extends Rule> filter) {
    for(token : tokens.tokens) {
      scopes.addAll(token)
    }
  }

  def dispatch IScope scopeFor(LexerRule rule) {
    val scopes = Lists.<EObject>newArrayList()
    val grammar = EcoreUtil.getRootContainer(rule) as Grammar

    lexerRules(grammar, scopes);

    // traverse prequels
    for (prequel : grammar.prequels) {
      try {
        scopeFor(prequel, scopes, LexerRule)
      } catch (IllegalArgumentException ex) {
        // not all the prequel define rules
      }
    }

    return Scopes.scopeFor(scopes, Antlr4NameProvider.nameFn, IScope.NULLSCOPE)
  }

  def lexerRules(Grammar grammar, List<EObject> scopes) {
    scopes.addAll(grammar.rules.filter(LexerRule))

    if (grammar.modes != null) {
      for(mode : grammar.modes) {
        scopes.add(mode)
        scopes.addAll(mode.rules.filter(LexerRule))
      }
    }
  }

  def rule(EObject object) {
    var root = object
    while (root != null && !(root instanceof Rule)) {
      root = root.eContainer
    }
    return root;
  }

}