package com.github.jknack;

import static com.google.common.base.Preconditions.checkNotNull;

import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.ILaunchManager;
import org.eclipse.xtext.generator.IOutputConfigurationProvider;
import org.eclipse.xtext.linking.ILinkingDiagnosticMessageProvider;
import org.eclipse.xtext.naming.IQualifiedNameProvider;

import com.github.jknack.antlr4.Antlr4Factory;
import com.github.jknack.generator.Antlr4OutputConfigurationProvider;
import com.github.jknack.scoping.Antlr4NameProvider;
import com.github.jknack.validation.Antlr4MissingReferenceMessageProvider;
import com.google.inject.Binder;

/**
 * The runtime module useful for create or customize Xtext.
 */
public class Antlr4RuntimeModule extends com.github.jknack.AbstractAntlr4RuntimeModule {

  @Override
  public void configure(final Binder binder) {
    checkNotNull(binder);

    super.configure(binder);

    binder.bind(Antlr4Factory.class).toInstance(Antlr4Factory.eINSTANCE);

    binder.bind(ILinkingDiagnosticMessageProvider.Extended.class)
        .to(Antlr4MissingReferenceMessageProvider.class);

    binder.bind(ILaunchManager.class).toInstance(getLaunchManager());
  }

  @Override
  public Class<? extends IQualifiedNameProvider> bindIQualifiedNameProvider() {
    return Antlr4NameProvider.class;
  }

  public Class<? extends IOutputConfigurationProvider> bindIOutputConfigurationProvider() {
    return Antlr4OutputConfigurationProvider.class;
  }

  protected ILaunchManager getLaunchManager() {
    return DebugPlugin.getDefault().getLaunchManager();
  }
}
